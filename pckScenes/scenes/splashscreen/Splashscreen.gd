extends Node

func _on_AnimationPlayer_animation_finished(_anim_name):
	var _sceneChange = get_tree().change_scene("res://scenes/mainmenu/MainMenu.tscn")
