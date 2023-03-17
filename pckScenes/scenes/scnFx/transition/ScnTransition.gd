extends CanvasLayer

onready var animPlayer = $AnimationPlayer

var changeScene = false
var sceneResource:String

func open():
	animPlayer.play_backwards("Doors")

func close(nextScene:String):
	changeScene = true
	sceneResource = nextScene
	animPlayer.play("Doors")

func _on_AnimationPlayer_animation_finished(_anim_name):
	if changeScene == true:
		var _changeScene = get_tree().change_scene(sceneResource)
