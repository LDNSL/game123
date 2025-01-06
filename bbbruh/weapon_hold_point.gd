extends Node3D
@onready var fps_rig = $fps_rig
@onready var animation_player = $fps_rig/shotgun/AnimationPlayer
var shotgun_in_use = true
var shotgun = true
var can_shoot = true
var shotgun_ammo_max = 7
var shotgun_ammo = 7
var shotgun_reload = 2
@onready var barrel__raycast: RayCast3D = $"barrel _raycast"
var bullet = load("res://materials/bullet.tscn")
var instance
var instance_2
var instance_3
var shotgun_damage = 3
@onready var shoot_position: RayCast3D = $"../../../../neck/head/eyes/Camera3D/shoot_position"
@onready var crosshair: SubViewportContainer = $"../../.."
@onready var shotgun_model: Node3D = $Shotgun/shotgun_model


enum weapons {
	SHOTGUN,
	REVOLVER,
}

var weapon = weapons.SHOTGUN
#bullet
var bullet_trial = load("res://scenes/bullettrial.tscn")


#bullet physics
@onready var aim_ray_end = $"../../../../neck/head/eyes/Camera3D/shoot_position/endpoint"
@onready var gun_bar = $Shotgun/shotgun_model/Node3D
		
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _input(event):
	if shotgun_in_use:
		if event.is_action_pressed("shoot"):
			shoot()
		if event.is_action_pressed("inspect"):
			inspect()
			print("inspect")
		if event.is_action_pressed("reload"):
			reload()			
	if event.is_action_pressed("use"):
		shotgun_in_use = !shotgun_in_use
		if shotgun_in_use:
			animation_player.play("equip_animation")
		else:
			animation_player.play_backwards("equip_animation")
@onready var character_body_3d: CharacterBody3D = $"../../../.."
func shoot():
	var damage = 0	
	#if !animation_player.is_playing() or can_shoot == true:
	match weapon:
		weapons.SHOTGUN:
			damage = 3
			#animation_player.play("shoot")
			can_shoot = false
	instance = bullet_trial.instantiate()
	if shoot_position.is_colliding():
		instance.init(gun_bar.global_position, shoot_position.get_collision_point())
		if shoot_position.get_collider().is_in_group("enemy"):
			shoot_position.get_collider().hit(damage)
			print("fire")
			crosshair.hitmarker()
		else:
			print(aim_ray_end.global_position)
			instance.init(gun_bar.global_position, aim_ray_end.global_position)
		character_body_3d.get_parent().add_child(instance)

		
func inspect():
	if shotgun_in_use == true:
		animation_player.play("reset")
		animation_player.play("inspect")
		can_shoot = true

func reload():
	if !animation_player.is_playing() or shotgun_in_use == true:
		animation_player.play("reset")
		animation_player.play("shell_reload")
		can_shoot = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	can_shoot = true
