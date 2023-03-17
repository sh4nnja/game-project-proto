extends Area2D

onready var animation = $AnimationPlayer

var canBlockBullets = true

func open():
	animation.play("door")
	yield(animation, "animation_finished")
	canBlockBullets = false
	
func close():
	animation.play_backwards("door")
	yield(animation, "animation_finished")
	canBlockBullets = true

func _on_Door_area_entered(area):
	if area.is_in_group("bullet") and canBlockBullets == true:
		area.queue_free()
	if area.is_in_group("bullet2") and canBlockBullets == true:
		area.queue_free()
