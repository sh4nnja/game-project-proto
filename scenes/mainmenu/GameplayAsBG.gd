extends Node

onready var gamePlay = $GameplayNodes
onready var background = $Background

onready var armoryParent = $GameplayNodes/Armory
onready var greenHouseParent = $GameplayNodes/Greenhouse
onready var electricalParent = $GameplayNodes/Electrical
onready var energyParent = $GameplayNodes/Energy
onready var centralParent = $GameplayNodes/Central

onready var armoryChunks = $GameplayNodes/Armory/Lights/Xelar/Chunks
onready var gunLight = $GameplayNodes/Armory/Lights/Gun
onready var gunLightAnim = $GameplayNodes/Armory/Lights/Gun/GunAnimation
onready var screenLight = $GameplayNodes/Armory/Lights/Screen
onready var whiteTube = $GameplayNodes/Armory/Lights/White
onready var laser = $GameplayNodes/Armory/Lights/Laser
onready var stand = $GameplayNodes/Armory/Lights/Stand
onready var stand2 = $GameplayNodes/Armory/Lights/Stand2
onready var stand3 = $GameplayNodes/Armory/Lights/Stand3

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
onready var warning = $GameplayNodes/Energy/Lights/Warning
onready var bot = $GameplayNodes/Energy/Lights/Bot
onready var bot2 = $GameplayNodes/Energy/Lights/Bot2

onready var tv = $GameplayNodes/Central/Tvs/Tv
onready var tvLight = $GameplayNodes/Central/Lights/TvLight

func _ready():
	armoryParent.show()
	greenHouseParent.show()
	electricalParent.show()
	energyParent.show()
	centralParent.show()

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


