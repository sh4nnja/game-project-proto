extends Area2D

onready var parent = get_parent()

var velocity = Vector2()
var bulletSpeed = 2000

func _physics_process(delta):
	self.position += self.transform.x * bulletSpeed * delta
	if self.position.x > 2500 or self.position.x < -2500:
		self.queue_free()
		
func _on_Bullet_body_entered(_body):
	pass

func _on_Bullet_area_entered(area):
	if area.is_in_group("dummy"):
		get_tree().root.get_node("/root/Gameplay/GameplayNodes/Player").shake("normal")
	if area.is_in_group("enemy"):
		get_tree().root.get_node("/root/Gameplay/GameplayNodes/Player").shake("normal")
