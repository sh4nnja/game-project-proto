extends Label

onready var floatingDamage = self
onready var floatingDamageTween = $Tween

func damagePopUp(value, travel, duration, spread, crit = false):
	floatingDamage.text = value
	var movement = travel.rotated(rand_range(-spread / 2, spread / 2))
	floatingDamage.rect_pivot_offset = floatingDamage.rect_size / 2
	floatingDamageTween.interpolate_property(self, "rect_position", floatingDamage.rect_position, floatingDamage.rect_position + movement, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	floatingDamageTween.interpolate_property(self, "modulate:a", 1.0, 0.0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	if crit:
		floatingDamage.modulate = Color(1, 0, 0)
		floatingDamageTween.interpolate_property(self, "rect_scale", floatingDamage.rect_scale * 2, floatingDamage.rect_scale, 0.4, Tween.TRANS_BACK, Tween.EASE_IN)
	floatingDamageTween.start()
	yield(floatingDamageTween, "tween_all_completed")
	queue_free()
