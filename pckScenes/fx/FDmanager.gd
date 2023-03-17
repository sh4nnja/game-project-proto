extends Node2D

var FCT = preload("res://pckScenes/fx/FloatingDamage.tscn")

var travel = Vector2(0, -80)
var duration = 1
var spread = PI/2.5

func damagePopUp(value, crit=false):
	var fct = FCT.instance()
	add_child(fct)
	fct.damagePopUp(str(value), travel, duration, spread, crit)
