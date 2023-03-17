extends Node

onready var gamePlay = $GameplayNodes
onready var spawn = $GameplayNodes/Spawn
onready var platform = $GameplayNodes/Platform
onready var bulletWall = $GameplayNodes/Platform/BulletCollision
onready var background = $Background

onready var armoryParent = $GameplayNodes/Armory
onready var greenHouseParent = $GameplayNodes/Greenhouse
onready var electricalParent = $GameplayNodes/Electrical
onready var energyParent = $GameplayNodes/Energy
onready var centralParent = $GameplayNodes/Central

onready var enemySpawn = $GameplayNodes/EnemySpawn

onready var transition = $Transition
onready var leftDoor = $Transition/Left
onready var rightDoor = $Transition/Right

onready var armoryChunks = $GameplayNodes/Armory/Lights/Xelar/Chunks
onready var gunLight = $GameplayNodes/Armory/Lights/Gun
onready var gunLightAnim = $GameplayNodes/Armory/Lights/Gun/GunAnimation
onready var screenLight = $GameplayNodes/Armory/Lights/Screen
onready var whiteTube = $GameplayNodes/Armory/Lights/White
onready var laser = $GameplayNodes/Armory/Lights/Laser
onready var stand = $GameplayNodes/Armory/Lights/Stand
onready var stand2 = $GameplayNodes/Armory/Lights/Stand2
onready var stand3 = $GameplayNodes/Armory/Lights/Stand3

onready var akEquipSound = $GameplayNodes/Armory/Ak47Module/EquipSound
onready var srEquipSound = $GameplayNodes/Armory/SniperModule/EquipSound2

onready var upperLights = $GameplayNodes/Greenhouse/Lights/Upper
onready var blossom = $GameplayNodes/Greenhouse/Lights/Blossom
onready var bamboo = $GameplayNodes/Greenhouse/Lights/Bamboo
onready var seeweed = $GameplayNodes/Greenhouse/Lights/Seeweed
onready var seeweedChunks = $GameplayNodes/Greenhouse/Lights/Seeweed/SeeweedChunks
onready var modules = $GameplayNodes/Greenhouse/Lights/Modules
onready var greenhouseStand = $GameplayNodes/Greenhouse/Lights/Stand
onready var greenhouseStand2 = $GameplayNodes/Greenhouse/Lights/Stand2
onready var plant = $GameplayNodes/Greenhouse/Lights/Plant

onready var core = $GameplayNodes/Electrical/Lights/Core
onready var screens = $GameplayNodes/Electrical/Lights/Screens
onready var books = $GameplayNodes/Electrical/Lights/Books
onready var lStand = $GameplayNodes/Electrical/Lights/LightStand
onready var lStand2 = $GameplayNodes/Electrical/Lights/LightStand2
onready var lStand3 = $GameplayNodes/Electrical/Lights/LightStand3

onready var sunlight = $GameplayNodes/Energy/Lights/Sun
onready var sunlight2 = $GameplayNodes/Energy/Lights/Sun2
onready var sunlight3 = $GameplayNodes/Energy/Lights/Sun3
onready var warning = $GameplayNodes/Energy/Lights/Warning
onready var bot = $GameplayNodes/Energy/Lights/Bot
onready var bot2 = $GameplayNodes/Energy/Lights/Bot2

onready var tv = $GameplayNodes/Central/Tvs/Tv
onready var tvLight = $GameplayNodes/Central/Lights/TvLight

onready var waves = $Enemy/GUI/EnemyWaves
onready var waveText = $Enemy/GUI/Wave
onready var location = $Enemy/GUI/Location

onready var player = load("res://pckScenes/player/Player.tscn")
onready var enemy = load("res://pckScenes/dummies/dummy1/Drone.tscn")

onready var enemyTimer = $Enemy/Timer

onready var rng = RandomNumberGenerator.new()

var spawnTimer = 5
var countDownMin = 45
var countDownMax = 90
var numOfBots = 1
var canSpawn = true

var numOfWaves = 0

var locations = [Vector2(378, 307), Vector2(1152, 119), Vector2(360, 115), Vector2(1265, 535), Vector2(1234, 680)]
var locName 

func _ready():
	transition.open()
	spawnPlayer()
	
	armoryParent.show()
	greenHouseParent.show()
	electricalParent.show()
	energyParent.show()
	centralParent.show()
	
	randomPosition()

func _process(_delta):
	wavesIndicator()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Doors":
		leftDoor.hide()
		rightDoor.hide()

func spawnPlayer():
	var playerInst = player.instance()
	gamePlay.add_child(playerInst)
	playerInst.position = spawn.position

func wavesIndicator():
	waves.value = get_tree().get_nodes_in_group("enemy").size()
	if waves.value == 0 or waves.value < 1:
		randomPosition()
	
	waveText.text = str(numOfWaves) + "\n" + str(get_tree().get_nodes_in_group("enemy").size()) + "\n" + str(stepify(float(enemyTimer.time_left), 0.1))
	location.text = "LOCATION: " + str(locName)
	
	if enemySpawn.position == Vector2(378, 307):
		locName = "Power Core"
	if enemySpawn.position == Vector2(1152, 119):
		locName = "Right Solar Room"
	if enemySpawn.position == Vector2(360, 115):
		locName = "Left Solar Room"
	if enemySpawn.position == Vector2(1265, 535):
		locName = "Upper Greenhouse"
	if enemySpawn.position == Vector2(1234, 680):
		locName = "Lower Greenhouse"
		
func randomPosition():
	if canSpawn == true:
		rng.randomize()
		numOfWaves += 1
		enemySpawn.position = locations[rng.randi_range(0, 4)]
		spawnEnemy()
		rng.randomize()
		enemyTimer.start(rng.randi_range(countDownMin, countDownMax))
	if numOfWaves > 1:
		GameModes.score += 5

func spawnEnemy():
	var offset = 50
	if canSpawn == true:
		rng.randomize()
		numOfBots = rng.randi_range(1, 5)
		for _i in range(numOfBots):
			var enemyInst = enemy.instance()
			gamePlay.add_child(enemyInst)
			rng.randomize()
			enemyInst.position.x = rng.randi_range(enemySpawn.position.x + offset, enemySpawn.position.x - offset)
			rng.randomize()
			enemyInst.position.y = rng.randi_range(enemySpawn.position.y + offset, enemySpawn.position.y - offset)
			waves.max_value = numOfBots

func _on_Timer_timeout():
	get_node("/root/Gameplay/Pause/GUI").paused = true
	get_node("/root/Gameplay/Pause/GUI").isPlayerDead = true
	get_node("GameplayNodes/Player").queue_free()

func _on_BulletCollision_area_entered(area):
	if area.is_in_group("bullet"):
		area.queue_free()
	if area.is_in_group("bullet2"):
		area.queue_free()

func _on_Equipweapon_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("GUILayer/GUI/AK47").show()

func _on_Equipweapon_body_exited(body):
	if body.is_in_group("Player"):
		body.get_node("GUILayer/GUI/AK47").hide()

func _on_Equipweapon2_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("GUILayer/GUI/Sniper").show()

func _on_Equipweapon2_body_exited(body):
	if body.is_in_group("Player"):
		body.get_node("GUILayer/GUI/Sniper").hide()
		
func _on_SuitUp_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("GUILayer/GUI/Suit").show()

func _on_SuitUp_body_exited(body):
	if body.is_in_group("Player"):
		body.get_node("GUILayer/GUI/Suit").hide()
	
func backgroundFx(type):
	if type == "Ak":
		background.texture = load("res://map/Background2-ak.png")
		gunLight.enabled = true
	elif type == "Sr":
		background.texture = load("res://map/Background2-sr.png")
		gunLight.enabled = false
	elif type == "Ak0":
		background.texture = load("res://map/Background2.png")
	elif type == "Sr0":
		background.texture = load("res://map/Background2.png")
		gunLight.enabled = true
		
func gunSound(type):
	if type == "Ak":
		akEquipSound.play()
	elif type == "Sr":
		srEquipSound.play()
		yield(get_tree().create_timer(1), "timeout")
		srEquipSound.stop()

func _on_Left_body_entered(body):
	if body.is_in_group("Player"):
		body.isPoisoned = true

func _on_Left_body_exited(body):
	if body.is_in_group("Player"):
		body.isPoisoned = false

func _on_Right_body_entered(body):
	if body.is_in_group("Player"):
		body.isPoisoned = true

func _on_Right_body_exited(body):
	if body.is_in_group("Player"):
		body.isPoisoned = false

func _on_XelarPerf_screen_entered():
	armoryChunks.emitting = true

func _on_XelarPerf_screen_exited():
	armoryChunks.emitting = false

func _on_GunPerf_screen_entered():
	gunLight.enabled = true
	gunLightAnim.play("Glow")

func _on_GunPerf_screen_exited():
	gunLight.enabled = false
	gunLightAnim.stop()

func _on_ScreenPerf_screen_entered():
	screenLight.enabled = true

func _on_ScreenPerf_screen_exited():
	screenLight.enabled = false
	
func _on_RedTubePerf_screen_entered():
	whiteTube.enabled = true

func _on_RedTubePerf_screen_exited():
	whiteTube.enabled = false

func _on_LaserPerf_screen_entered():
	laser.enabled = true

func _on_LaserPerf_screen_exited():
	laser.enabled = false

func _on_StandPerf_screen_entered():
	stand.enabled = true

func _on_StandPerf_screen_exited():
	stand.enabled = false

func _on_Stand2Perf_screen_entered():
	stand2.enabled = true

func _on_Stand2Perf_screen_exited():
	stand2.enabled = false

func _on_Stand3Perf_screen_entered():
	stand3.enabled = true

func _on_Stand3Perf_screen_exited():
	stand3.enabled = false

func _on_UpperPerf_screen_entered():
	upperLights.enabled = true

func _on_UpperPerf_screen_exited():
	upperLights.enabled = false

func _on_BlossomPerf_screen_entered():
	blossom.enabled = true

func _on_BlossomPerf_screen_exited():
	blossom.enabled = false

func _on_BambooPerf_screen_entered():
	bamboo.enabled = true

func _on_BambooPerf_screen_exited():
	bamboo.enabled = false

func _on_SeeweedPerf_screen_entered():
	seeweed.enabled = true
	seeweedChunks.emitting = true

func _on_SeeweedPerf_screen_exited():
	seeweed.enabled = false
	seeweedChunks.emitting = false

func _on_ModulesPerf_screen_entered():
	modules.enabled = true

func _on_ModulesPerf_screen_exited():
	modules.enabled = false

func _on_GStandPerf_screen_entered():
	greenhouseStand.enabled = true

func _on_GStandPerf_screen_exited():
	greenhouseStand.enabled = false

func _on_GStand2Perf_screen_entered():
	greenhouseStand2.enabled = true

func _on_GStand2Perf_screen_exited():
	greenhouseStand2.enabled = false

func _on_PlantPerf_screen_entered():
	plant.enabled = true

func _on_PlantPerf_screen_exited():
	plant.enabled = false

func _on_CorePerf_screen_entered():
	core.enabled = true

func _on_CorePerf_screen_exited():
	core.enabled = false

func _on_ScreensPerf_screen_entered():
	screens.enabled = true

func _on_ScreensPerf_screen_exited():
	screens.enabled = false

func _on_BooksPerf_screen_entered():
	books.enabled = true

func _on_BooksPerf_screen_exited():
	books.enabled = false

func _on_LtPerf_screen_entered():
	lStand.enabled = true

func _on_LtPerf_screen_exited():
	lStand.enabled = false

func _on_LtPerf2_screen_entered():
	lStand2.enabled = true

func _on_LtPerf2_screen_exited():
	lStand2.enabled = false
	
func _on_LtPerf3_screen_entered():
	lStand3.enabled = true

func _on_LtPerf3_screen_exited():
	lStand3.enabled = false

func _on_SunPerf_screen_entered():
	sunlight.enabled = true

func _on_SunPerf_screen_exited():
	sunlight.enabled = false

func _on_SunPerf2_screen_entered():
	sunlight2.enabled = true

func _on_SunPerf2_screen_exited():
	sunlight2.enabled = false

func _on_SunPerf3_screen_entered():
	sunlight3.enabled = true

func _on_SunPerf3_screen_exited():
	sunlight3.enabled = false

func _on_WarnPerf_screen_entered():
	warning.enabled = true

func _on_WarnPerf_screen_exited():
	warning.enabled = false

func _on_BotPerf_screen_entered():
	bot.enabled = true

func _on_BotPerf_screen_exited():
	bot.enabled = false

func _on_BotPerf2_screen_entered():
	bot2.enabled = true

func _on_BotPerf2_screen_exited():
	bot2.enabled = false

func _on_TvPerf_screen_entered():
	tv.playing = true
	tvLight.enabled = true

func _on_TvPerf_screen_exited():
	tv.playing = false
	tvLight.enabled = false
