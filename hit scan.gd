extends Camera3D
@onready var fps_rig = $fps_rig
@onready var animation_player = $fps_rig/shotgun/AnimationPlayer
var shotgun_in_use = true
var shotgun = true
var shotgun_ammo_max = 7
var shotgun_ammo = 7
var shotgun_reload = 2
@onready var barrel__raycast: RayCast3D = $"barrel _raycast"
var bullet = load("res://materials/bullet.tscn")
var instance
var instance_2
var instance_3
var shotgun_damage = 3
@onready var ray_cast_3d: RayCast3D = $"../../../RayCast3D"
@onready var shoot_position: RayCast3D = $"../../../shoot_position"
@onready var crosshair: TextureRect = $"SubViewportContainer2/SubViewport/normal cross"
@onready var hit_cross_hair: TextureRect = $"SubViewportContainer2/SubViewport/hit cross hair"




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crosshair.position.x = get_viewport().size.x / 2 -32
	crosshair.position.y = get_viewport().size.y / 2 -32
	hit_cross_hair.position.x = get_viewport().size.x / 2 -32
	hit_cross_hair.position.y = get_viewport().size.y / 2 -32


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fps_rig.position.x = lerp(fps_rig.position.x , 0.0, delta * 5)
	fps_rig.position.y = lerp(fps_rig.position.y , 0.0, delta * 5)

func sway(sway_amount):
	fps_rig.position.x -= sway_amount.x * 0.00005
	fps_rig.position.y += sway_amount.y * 0.00005
	
func _input(event):
	if event.is_action_pressed("right click"):
		print("shoot")
		shoot()
	if event.is_action_pressed("inspect"):
		inspect()
		print("inspect")
	if event.is_action_pressed("reload"):
		reload()			
	if event.is_action_pressed("use"):
		shotgun_in_use = !shotgun_in_use
		if shotgun_in_use:
			animation_player.play("Pull_up")
		else:
			animation_player.play("Pull_DOWN")
		
func shoot():
	var damage = shotgun_damage
	if !animation_player.is_playing():
		animation_player.play("fire")
		if shoot_position.is_colliding():
			if shoot_position.get_collider().is_in_group("enemy"):
				shoot_position.get_collider().hit(damage)
		
func inspect():
	animation_player.play("inspect")

func reload():
	animation_player.play("reload")
	
