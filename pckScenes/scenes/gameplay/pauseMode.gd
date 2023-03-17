extends Control

onready var pausePlayer = $PausePlayer
onready var pausedText = $Paused
onready var toMainmenu = $Mainmenu
onready var score = $Score

var isPlayerDead = false
var paused = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and isPlayerDead == false:
		if paused == false:
			get_tree().paused = true
			paused = true
			pausePlayer.play("fade")
			pausedText.text = "-GAME PAUSED | PRESS ESC TO CONTINUE-"
			get_node("/root/Gameplay/Enemy/GUI").hide()
			show()
		
		elif paused == true:
			get_tree().paused = false
			paused = false
			pausePlayer.stop()
			get_node("/root/Gameplay/Enemy/GUI").show()
			hide()
			
	if isPlayerDead == true:
		get_tree().paused = true
		get_node("/root/Gameplay/Enemy/GUI").hide()
		pausedText.text = "-YOU DIED-"
		pausePlayer.play("fade")
		toMainmenu.show()
		show()
	
	score.text = "Score: " + str(GameModes.score)

func _on_Mainmenu_pressed():
	var _changeScene = get_tree().change_scene_to(preload("res://scenes/mainmenu/MainMenu.tscn"))
	get_tree().paused = false
