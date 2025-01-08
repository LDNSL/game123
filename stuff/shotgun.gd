extends Node3D
@onready var fps_rig = $".."
@onready var animation_player = $AnimationPlayer
var shotgun_in_use = true
var shotgun = true
var can_shoot = true
var shotgun_ammo_max = 7
var shotgun_ammo = 7
var shotgun_reload = 2
var damage = 0
@onready var barrel__raycast: RayCast3D = $"barrel _raycast"
var bullet = load("res://materials/bullet.tscn")
@onready var shoot_position = $"../../../../../../neck/head/eyes/Camera3D/shoot_position"
#weapon sounds
@onready var gun_sounds: AudioStreamPlayer3D = $"shotgun_model/gun sounds"
@onready var gun_reload: AudioStreamPlayer3D = $"shotgun_model/gun reload"
@onready var gun_dry_fire: AudioStreamPlayer3D = $shotgun_model/gun_dry_fire
@onready var crosshair: SubViewportContainer = $"../../../../../../neck/head/eyes/Camera3D/SubViewportContainer2"
var instance
enum weapons {
	SHOTGUN,
	REVOLVER,
}

var weapon = weapons.SHOTGUN
#bullet
var bullet_trial = load("res://scenes/bullettrial.tscn")


#bullet physics
@onready var aim_ray_end = $"../../../../../../neck/head/eyes/Camera3D/shoot_position/endpoint"
@onready var gun_bar = $"../../../../../../Node3D"
var ammo = 4
var maxammo = 7

func _input(event):
	if shotgun_in_use:
		if event.is_action_pressed("shoot"):
			shoot()
		if event.is_action_pressed("inspect"):
			inspect()
			print("inspect")
		if event.is_action_pressed("reload"):
			reload()
@onready var character_body_3d: CharacterBody3D = 	$"../../../../../.."
func shoot():
	if !animation_player.is_playing() and ammo > 0 or can_shoot == true and ammo > 0:
		match weapon:
			weapons.SHOTGUN:
				damage = 3
				can_shoot = false
				gun_sounds.play()
				animation_player.play("shoot")
				ammo += -1
				#instance = bullet_trial.instantiate()
		if shoot_position.is_colliding():
			#instance.init(gun_bar.global_position, shoot_position.get_collision_point())
			if shoot_position.get_collider().is_in_group("enemy"):
				shoot_position.get_collider().hit(damage)
				print("fire")
				crosshair._hitmarker()
		else:
			print(aim_ray_end.global_position)
			#instance.init(gun_bar.global_position, aim_ray_end.global_position)
		#character_body_3d.get_parent().add_child(instance)
	elif ammo < 1:
		gun_dry_fire.play()
		
		
func inspect():
	if shotgun_in_use == true:
		animation_player.play("reset")
		animation_player.play("inspect")
		can_shoot = true

func reload():
	if !animation_player.is_playing() and ammo <= maxammo - 1:
		animation_player.play("reset")
		animation_player.play("shell_reload")
		gun_reload.play()
		ammo += 1
		can_shoot = false

func equip():
	if shotgun_in_use:
		animation_player.play("equip_animation")
	else:
		animation_player.play_backwards("equip_animation")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	can_shoot = true
