extends KinematicBody2D

onready var texture = $Texture
onready var areaEnemy = $Area2D
onready var collisionShape = $Shape
onready var FD = $FDmanager
onready var light = $light

onready var fx = load("res://pckScenes/dummies/dummy1/fx.tscn")

var velocity = Vector2()
var react_time = 400
var direction = 0
var next_direction = 0
var next_direction_time = 0
var target_distance = 60

var deathState = false

var player

var health = 25
var tracking = false


func set_direction(target_direction):
	if next_direction != target_direction:
		next_direction = target_direction
		next_direction_time = OS.get_ticks_msec() + react_time
		
func _physics_process(_delta):
	if tracking == true:
		if player.position.x < self.position.x - target_distance:
			set_direction(-1)
			texture.flip_h = false
		elif player.position.x > self.position.x + target_distance:
			set_direction(1)
			texture.flip_h = true
		else: 
			set_direction(0)
		if OS.get_ticks_msec() > next_direction_time:
			direction = next_direction
		velocity.x = 25 * direction
		if player.position.y < self.position.y:
			self.position.y += -0.1
		elif player.position.y > self.position.y:
			self.position.y -= -0.1
		
	elif tracking == false:
		set_direction(0)
		velocity.x = 0

	healthCheck()
	velocity = move_and_slide(velocity)

func healthCheck():
	if health <= 0:
		tracking = false
		light.enabled = false
		var smoke = fx.instance()
		get_node("/root/Gameplay/GameplayNodes").add_child(smoke)
		smoke.position = position
		smoke.get_child(0).emitting = true
		GameModes.score += 5
		queue_free()

func _on_Area2D_area_entered(area):
	if area.is_in_group("bullet"):
		health -= GameModes.globalDamageRifle
		FD.damagePopUp(15, false)
		area.queue_free()
	elif area.is_in_group("bullet2"):
		health -= GameModes.globalDamageSniper
		FD.damagePopUp(40, true)
		area.queue_free()

func _on_Detection_body_entered(body):
	tracking = true
	player = body

func _on_Detection_body_exited(_body):
	tracking = false


func _on_Area2D2_body_entered(body):
	if body.is_in_group("Player"):
		body.isAttacked = true

func _on_Area2D2_body_exited(body):
	if body.is_in_group("Player"):
		body.isAttacked = false

func _on_VisibilityNotifier2D_screen_entered():
	light.enabled = true


func _on_VisibilityNotifier2D_screen_exited():
	light.enabled = false



