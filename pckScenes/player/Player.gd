extends KinematicBody2D

onready var animationPlayer = $TexturePlayer
onready var camera = $Camera2D
onready var animation = $AnimationPlayer
onready var hand = $hand
onready var crack = $GUILayer/GUI/DeathScreen

onready var armorBar = $GUILayer/GUI/Armor
onready var lifeMana = $"GUILayer/GUI/Life|Mana"
onready var gunSlot = $GUILayer/GUI/GunSlot/Gun
onready var gunName = $GUILayer/GUI/GunSlot/Name

onready var map = $GUILayer/GUI/Map/GUI

onready var sfx = $FX

onready var ak47Button = $GUILayer/GUI/AK47
onready var sniperButton = $GUILayer/GUI/Sniper
onready var suitButton = $GUILayer/GUI/Suit
onready var wearSuit = $GUILayer/GUI/WearSuit

onready var cmdBtn = $GUILayer/GUI/CmdBtn
onready var elecBtn = $GUILayer/GUI/ElecBtn
onready var armoryBtn = $GUILayer/GUI/ArmoryBtn
onready var ghBtn = $GUILayer/GUI/GreenhouseBtn

onready var ak = load("res://pckScenes/guns/gun-1/1.tscn")
onready var sr = load("res://pckScenes/guns/gun-2/2.tscn")

var gravity = 550
var velocity = Vector2(0, 0)
var speed = 150
var jumpSpeed = -250
var friction = 0.15
var acceleration = 0.5
var ladderSpeed = 250

var characterSelected
var isSuitEquipped = false
var isMoving = false
var inLadder = false
var canFire = true
var isPoisoned = false
var isAttacked = false
var canRegen = false
var onAModule = false

var health = 100
var armor = 100

var damage = 1
var regen = 0.001

#VIRTUAL
func _ready():
	characterSelected = GameModes.character
	
	ak47Button.hide()
	sniperButton.hide()
	suitButton.hide()
	wearSuit.hide()
	
	cmdBtn.hide()
	elecBtn.hide()
	armoryBtn.hide()
	ghBtn.hide()
	
func _process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)

	get_input()
	checkCharacterSelected()
	rotateGun()
	healthAndArmor()
	regenMode()
	gunInfo()
	poisoned()
	attacked()

#MOVEMENT
func get_input():
	var direction = 0
	if Input.is_action_pressed("right"):
		animationPlayer.flip_h = false
		direction += 1
		if Input.is_action_pressed("Shift"):
			animationPlayer.flip_h = true
		
	if Input.is_action_pressed("left"):
		animationPlayer.flip_h = true
		direction -= 1
		if Input.is_action_pressed("Shift"):
			animationPlayer.flip_h = false
		
	if Input.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y = jumpSpeed
			
	if inLadder == true:
		gravity = 0 
		velocity.y = 0
		if Input.is_action_pressed("up"):
			velocity.y -= ladderSpeed
		elif Input.is_action_pressed("down"):
			velocity.y += ladderSpeed
	else:
		gravity = 550
		
	if Input.is_action_pressed("MAP"):
		map.show()
	if Input.is_action_just_released("MAP"):
		map.hide()
		
	if direction != 0: #MOVING
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
		sfx.stream_paused = false
		isMoving = true

	else: #STOPPING
		velocity.x = lerp(velocity.x, 0, friction)
		sfx.stream_paused = true
		isMoving = false

################################################################################

func checkCharacterSelected():
	if isSuitEquipped == false:
		match characterSelected:
			"Blue":
				if isMoving == true:
					animationPlayer.animation = "run-blue"
				else:
					animationPlayer.animation = "idle-blue"
			"Brown":
				if isMoving == true:
					animationPlayer.animation = "run-brown"
				else:
					animationPlayer.animation = "idle-brown"
			"Purple":
				if isMoving == true:
					animationPlayer.animation = "run-purple"
				else:
					animationPlayer.animation = "idle-purple"
			"Red":
				if isMoving == true:
					animationPlayer.animation = "run-red"
				else:
					animationPlayer.animation = "idle-red"
			"White":
				if isMoving == true:
					animationPlayer.animation = "run-white"
				else:
					animationPlayer.animation = "idle-white"
	else:
		if isMoving == true:
			animationPlayer.animation = "run-suit"
		else:
			animationPlayer.animation = "idle-suit"

func rotateGun():
	if hand.get_child_count() > 0:
		if animationPlayer.flip_h == true:
			if hand.get_child(0).is_in_group("1"):
				hand.get_child(0).scale.x = -1.95
			elif hand.get_child(0).is_in_group("2"):
				hand.get_child(0).scale.x = -2.5
		else:
			if hand.get_child(0).is_in_group("1"):
				hand.get_child(0).scale.x = 1.95
			elif hand.get_child(0).is_in_group("2"):
				hand.get_child(0).scale.x = 2.5
				
func gunInfo():
	if hand.get_child_count() == 0:
		ak47Button.text = "EQUIP QPG2-097"
		sniperButton.text = "EQUIP PPT-082"
	elif hand.get_child_count() > 0:
		if hand.get_child(0).is_in_group("1"):
			ak47Button.text = "UNEQUIP QPG2-097"
			sniperButton.text = "EQUIP PPT-082"
		elif hand.get_child(0).is_in_group("2"):
			ak47Button.text = "EQUIP QPG2-097"
			sniperButton.text = "UNEQUIP PPT-082"

func healthAndArmor():
	armorBar.value = armor
	lifeMana.value = health
	
	if armor <= 0:
		health -= 0.25
		crack.show()
	
	if health < 15:
		canFire = false
	if health >= 100:
		canFire = true
		crack.hide()
	if health <= 0:
		get_node("/root/Gameplay/Pause/GUI").paused = true
		get_node("/root/Gameplay/Pause/GUI").isPlayerDead = true
		self.queue_free()

func regenMode():
	if hand.get_child_count() == 0 and armor > 0:
		health = lerp(health, 100, regen)
		canFire = true
	elif hand.get_child_count() > 0 and armor > 0:
		if health < 100 and hand.get_child(0).isFiring == false:
			health = lerp(health, 100, regen)
			canFire = true
	
	if armor < 100 and canRegen == true:
		armor = lerp(armor, 100, regen)
		wearSuit.hide()

func poisoned():
	if isSuitEquipped == false and isPoisoned == true:
		canRegen = false
		armor -= 0.5
		wearSuit.show()
	else:
		canRegen = true

func attacked():
	if isAttacked == true:
		canRegen = false
		armor -= 0.6
	else:
		canRegen = true

func _on_EquipZone_area_entered(area):
	if area.is_in_group("ladderMid"):
		inLadder = true
		sfx.volume_db = -80
	if area.is_in_group("door"):
			area.open()

func _on_EquipZone_area_exited(area):
	if area.is_in_group("ladderMid"):
		inLadder = false
		sfx.volume_db = 5
	if area.is_in_group("door"):
			area.close()
		
func shake(mode):
	if mode == "normal":
		animation.play("shake")
	elif mode == "hard":
		animation.play("shakeII")

func _on_AK47_pressed():
	get_node("/root/Gameplay").gunSound("Ak")
	if hand.get_child_count() == 0:
		var gunInst = ak.instance()
		hand.add_child(gunInst)
		hand.get_child(0).equip = true
		get_node("/root/Gameplay").backgroundFx("Ak")
		gunSlot.texture = load("res://pckScenes/guns/gun-1/gun.png")
		gunName.text = "QPG2-097"
	elif hand.get_child_count() > 0:
		if hand.get_child(0).is_in_group("1"):
			hand.get_child(0).queue_free()
			get_node("/root/Gameplay").backgroundFx("Ak0")
			gunSlot.texture = null
			gunName.text = ""
		elif hand.get_child(0).is_in_group("2"):
			var gunInst = ak.instance()
			hand.get_child(0).queue_free()
			yield(get_tree().create_timer(0.1), "timeout")
			hand.add_child(gunInst)
			hand.get_child(0).equip = true
			get_node("/root/Gameplay").backgroundFx("Ak")
			gunSlot.texture = load("res://pckScenes/guns/gun-1/gun.png")
			gunName.text = "QPG2-097"

func _on_Sniper_pressed():
	get_node("/root/Gameplay").gunSound("Sr")
	if hand.get_child_count() == 0:
		var gunInst = sr.instance()
		hand.add_child(gunInst)
		hand.get_child(0).equip = true
		get_node("/root/Gameplay").backgroundFx("Sr")
		gunSlot.texture = load("res://pckScenes/guns/gun-2/gun.png")
		gunName.text = "PPT-082"
	elif hand.get_child_count() > 0:
		if hand.get_child(0).is_in_group("2"):
			hand.get_child(0).queue_free()
			get_node("/root/Gameplay").backgroundFx("Sr0")
			gunSlot.texture = null
			gunName.text = ""
		elif hand.get_child(0).is_in_group("1"):
			var gunInst = sr.instance()
			hand.get_child(0).queue_free()
			yield(get_tree().create_timer(0.1), "timeout")
			hand.add_child(gunInst)
			hand.get_child(0).equip = true
			get_node("/root/Gameplay").backgroundFx("Sr")
			gunSlot.texture = load("res://pckScenes/guns/gun-2/gun.png")
			gunName.text = "PPT-082"
			
func _on_Suit_toggled(button_pressed):
	if button_pressed == true:
		isSuitEquipped = true
		suitButton.text = "UNEQUIP SUIT"
	else:
		isSuitEquipped = false
		suitButton.text = "EQUIP SUIT"

func _on_CmdBtn_toggled(button_pressed):
	if button_pressed == true:
		cmdBtn.text = "Close Command Console"
		get_node("/root/Gameplay/Tasks/Tasks/Command/CommandPlayer").play("open")
		onAModule = true
	else:
		cmdBtn.text = "Open Command Console"
		get_node("/root/Gameplay/Tasks/Tasks/Command/CommandPlayer").play_backwards("open")
		onAModule = false

func _on_ElecBtn_toggled(button_pressed):
	if button_pressed == true:
		elecBtn.text = "Close Electrical Console"
		get_node("/root/Gameplay/Tasks/Tasks/Electrical/ElecPlayer").play("open")
		onAModule = true
	else:
		elecBtn.text = "Open Electrical Console"
		get_node("/root/Gameplay/Tasks/Tasks/Electrical/ElecPlayer").play_backwards("open")
		onAModule = false

func _on_ArmoryBtn_toggled(button_pressed):
	if button_pressed == true:
		armoryBtn.text = "Close Armory Console"
		get_node("/root/Gameplay/Tasks/Tasks/Armory/ArmoryPlayer").play("open")
		onAModule = true
	else:
		armoryBtn.text = "Open Armory Console"
		get_node("/root/Gameplay/Tasks/Tasks/Armory/ArmoryPlayer").play_backwards("open")
		onAModule = false

func _on_GreenhouseBtn_toggled(button_pressed):
	if button_pressed == true:
		ghBtn.text = "Close Greenhouse Console"
		get_node("/root/Gameplay/Tasks/Tasks/Greenhouse/GreenHPlayer").play("open")
		onAModule = true
	else:
		ghBtn.text = "Open Greenhouse Console"
		get_node("/root/Gameplay/Tasks/Tasks/Greenhouse/GreenHPlayer").play_backwards("open")
		onAModule = false
