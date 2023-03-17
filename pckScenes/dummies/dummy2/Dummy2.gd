extends Area2D

onready var FDmanager = $FDmanager
onready var animationPlayer = $Texture

var time = 0.2

func _on_Dummy_area_entered(area):
	if area.is_in_group("bullet"):
		area.queue_free()
		animationPlayer.set_frame(1)
		yield(get_tree().create_timer(time), "timeout")
		animationPlayer.set_frame(0)
		
		
		FDmanager.damagePopUp(GameModes.globalDamageRifle, false)
	
	elif area.is_in_group("bullet2"):
		area.queue_free()
		animationPlayer.set_frame(1)
		yield(get_tree().create_timer(time), "timeout")
		animationPlayer.set_frame(0)
		
		FDmanager.damagePopUp(GameModes.globalDamageSniper, true)

func _on_VisibilityNotifier2D_screen_entered():
	self.show()
	
func _on_VisibilityNotifier2D_screen_exited():
	self.hide()
