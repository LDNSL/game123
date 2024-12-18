extends CharacterBody3D

@onready var bullet: CharacterBody3D = $"."
var prev_pos = Vector3.ZERO
var bulletflydirection = Vector3.ZERO

var SPEED = 300
const JUMP_VELOCITY = 4.5
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
func _ready():
	var bulletflydirection = global_transform.basis.z
	prev_pos = global_transform.origin
	
	pass

func _physics_process(delta: float) -> void:
	var newpos = Vector3(global_transform.origin - (bulletflydirection * SPEED * delta))
	print(newpos)
	global_transform.origin = newpos
	prev_pos = newpos
	
