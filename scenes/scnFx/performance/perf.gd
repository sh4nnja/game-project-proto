extends Node2D

onready var stats = $GUI/Stats

func _physics_process(_delta):
	stats.text = "FPS: " + str(Engine.get_frames_per_second()) + "\n"
