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
@onready var ray_cast_3d: RayCast3D = $"../../../RayCast3D"

enum weapons {
	SHOTGUN,
	REVOLVER,
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fps_rig.position.x = lerp(fps_rig.position.x , 0.0, delta * 5)
	fps_rig.position.y = lerp(fps_rig.position.y , 0.0, delta * 5)

func sway(sway_amount):
	fps_rig.position.x -= sway_amount.x * 0.00005
	fps_rig.position.y += sway_amount.y * 0.00005
	
func _input(event):
	if shotgun:
		if shotgun_in_use:
			if event.is_action_pressed("inspect"):
				animation_player.play("inspect")
			if event.is_action_pressed("shoot"):
				if !animation_player.is_playing():
					animation_player.play("fire")
					instance = bullet.instantiate()
					instance.position = ray_cast_3d.global_position 
					instance.transform.basis = ray_cast_3d.global_transform.basis
					get_parent().add_child(instance)
				
			if event.is_action_pressed("reload"):
				print("reload")
				animation_player.play("reload")
		if event.is_action_pressed("use"):
			shotgun_in_use = !shotgun_in_use
			if shotgun_in_use:
				animation_player.play("Pull_up")
			else:
				animation_player.play("Pull_DOWN")
func jumpstep_stun():
	print("jumpstun")		
