extends Node2D

onready var animPlayer = $AnimationPlayer
onready var muzzle = $Position2D
onready var muzzleFlash = $MuzzleFlash/Flash
onready var gun = $Gun
onready var sfx = $FX

var equip = false
var isFiring = false
var fireRate = 3

var bullet = load("res://pckScenes/guns/gun-1/Bullet.tscn")
var bulletFired = 0

func _ready():
	animPlayer.playback_speed = fireRate

func _physics_process(_delta):
	shoot()
	
func shoot():
	if equip == true:
		if Input.is_action_pressed("leftMouse") and get_parent().get_parent().health > 0 and get_parent().get_parent().canFire == true and get_parent().get_parent().onAModule == false:
			isFiring = true
		else:
			isFiring = false
			
	if isFiring == true:
		animPlayer.play("GunFiring")
	else:
		animPlayer.play("ScopeMovement")

func shootProjectile():
	var bulletInst = bullet.instance()
	get_parent().get_parent().get_parent().add_child(bulletInst)
	bulletInst.transform = muzzle.global_transform
	get_parent().get_parent().shake("normal")
	sfx.play()
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "GunFiring":
		shootProjectile()
		get_parent().get_parent().health -= get_parent().get_parent().damage * 5
		if get_parent().get_parent().get_node("TexturePlayer").flip_h == true:
			get_parent().get_parent().position.x += 1
		elif get_parent().get_parent().get_node("TexturePlayer").flip_h == false:
			get_parent().get_parent().position.x -= 1


