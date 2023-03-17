extends Node

onready var animPlayer = $AnimationPlayer
onready var transition = $UI/SCENE_FX/Transition

onready var playBtn = $UI/GUI/Menu/MenuBtns/Panel/StartBtn
onready var characterBtn = $UI/GUI/Menu/MenuBtns/Panel/CharacterBtn
onready var settingsBtn = $UI/GUI/Menu/MenuBtns/Panel/SettingsBtn
onready var aboutBtn = $UI/GUI/Menu/MenuBtns/Panel/AboutBtn

onready var redBtn = $UI/GUI/Menu/CharacterTab/Panel/ScrollContainer/CharacterSelection/Red
onready var brownBtn = $UI/GUI/Menu/CharacterTab/Panel/ScrollContainer/CharacterSelection/Brown
onready var whiteBtn = $UI/GUI/Menu/CharacterTab/Panel/ScrollContainer/CharacterSelection/White
onready var blueBtn = $UI/GUI/Menu/CharacterTab/Panel/ScrollContainer/CharacterSelection/Blue
onready var violetBtn = $UI/GUI/Menu/CharacterTab/Panel/ScrollContainer/CharacterSelection/Violet

onready var previewCharacter = $UI/GUI/Menu/CharacterTab/Panel/Preview
onready var pleaseSC = $UI/GUI/Menu/CharacterTab/Panel/PSC

onready var startBtn = $UI/GUI/Start

var characterSelected

func _ready():
	pass

func _process(_delta):
	showPSC()
	
func _on_AnimationPlayer_animation_finished(_anim_name):
	pass
	
func _on_Start_pressed():
	startBtn.hide()
	animPlayer.play("Intro")
	
func _on_StartBtn_pressed():
		if characterSelected == null:
			characterBtn.pressed = true
		else:
			GameModes.character = characterSelected
			transition.close("res://scenes/gameplay/Gameplay.tscn")
		
func _on_CharacterBtn_toggled(button_pressed):
	if button_pressed == true:
		if aboutBtn.pressed == true:
			_on_AboutBtn_toggled(false)
			yield(animPlayer, "animation_finished")
			animPlayer.play("Character")
		else:
			animPlayer.play("Character")
	if button_pressed == false:
		characterBtn.pressed = false
		animPlayer.play_backwards("Character")
		
func showPSC():
	if characterSelected == null:
		pleaseSC.show()
	else:
		pleaseSC.hide()

func _on_AboutBtn_toggled(button_pressed):
	if button_pressed == true:
		if characterBtn.pressed == true:
			
			_on_CharacterBtn_toggled(false)
			yield(animPlayer, "animation_finished")
			animPlayer.play("About")
		else:
			animPlayer.play("About")
	if button_pressed == false:
		aboutBtn.pressed = false
		animPlayer.play_backwards("About")

func _on_SettingsBtn_toggled(button_pressed):
	if button_pressed == true:
		print("SETTING PRESSED")

func _on_Blue_toggled(button_pressed):
	if button_pressed == true:
		if brownBtn.pressed == true:
			_on_Brown_toggled(false)
		elif redBtn.pressed == true:
			_on_Red_toggled(false)
		elif whiteBtn.pressed == true:
			_on_White_toggled(false)
		elif violetBtn.pressed == true:
			_on_Violet_toggled(false)
		characterSelected = "Blue"
		previewCharacter.texture = load("res://scenes/mainmenu/assets/UI/sprites/proto2.png")
	if button_pressed == false:
		blueBtn.pressed = false
		previewCharacter.texture = null
		characterSelected = null

func _on_Brown_toggled(button_pressed):
	if button_pressed == true:
		if redBtn.pressed == true:
			_on_Red_toggled(false)
		elif blueBtn.pressed == true:
			_on_Blue_toggled(false)
		elif whiteBtn.pressed == true:
			_on_White_toggled(false)
		elif violetBtn.pressed == true:
			_on_Violet_toggled(false)
		characterSelected = "Brown"
		previewCharacter.texture = load("res://scenes/mainmenu/assets/UI/sprites/proto1.png")
	if button_pressed == false:
		brownBtn.pressed = false
		previewCharacter.texture = null
		characterSelected = null

func _on_Violet_toggled(button_pressed):
	if button_pressed == true:
		if brownBtn.pressed == true:
			_on_Brown_toggled(false)
		elif blueBtn.pressed == true:
			_on_Blue_toggled(false)
		elif whiteBtn.pressed == true:
			_on_White_toggled(false)
		elif redBtn.pressed == true:
			_on_Red_toggled(false)
		characterSelected = "Purple"
		previewCharacter.texture = load("res://scenes/mainmenu/assets/UI/sprites/proto4.png")
	if button_pressed == false:
		violetBtn.pressed = false
		previewCharacter.texture = null
		characterSelected = null

func _on_Red_toggled(button_pressed):
	if button_pressed == true:
		if brownBtn.pressed == true:
			_on_Brown_toggled(false)
		elif blueBtn.pressed == true:
			_on_Blue_toggled(false)
		elif whiteBtn.pressed == true:
			_on_White_toggled(false)
		elif violetBtn.pressed == true:
			_on_Violet_toggled(false)
		characterSelected = "Red"
		previewCharacter.texture = load("res://scenes/mainmenu/assets/UI/sprites/proto0.png")
	if button_pressed == false:
		redBtn.pressed = false
		previewCharacter.texture = null
		characterSelected = null

func _on_White_toggled(button_pressed):
	if button_pressed == true:
		if brownBtn.pressed == true:
			_on_Brown_toggled(false)
		elif blueBtn.pressed == true:
			_on_Blue_toggled(false)
		elif redBtn.pressed == true:
			_on_Red_toggled(false)
		elif violetBtn.pressed == true:
			_on_Violet_toggled(false)
		characterSelected = "White"
		previewCharacter.texture = load("res://scenes/mainmenu/assets/UI/sprites/proto3.png")
	if button_pressed == false:
		whiteBtn.pressed = false
		previewCharacter.texture = null
		characterSelected = null



