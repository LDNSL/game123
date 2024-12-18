extends CharacterBody3D

@onready var bullet: CharacterBody3D = $"."
var prev_pos = Vector3.ZERO

const SPEED = 300
const JUMP_VELOCITY = 4.5
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
func _ready():
	if ray_cast_3d.is_colliding():
		velocity = Vector3.ZERO
		var target = ray_cast_3d.get_collider()
		if target:
			if target.is_in_group("enemy"):
				print("enemy hit")
				target.hit()
		print("collding")
		collision_shape_3d.disabled = true
		mesh_instance_3d.visible = false
		gpu_particles_3d.emitting = true
		queue_free()

func _physics_process(delta: float) -> void:
	if ray_cast_3d.is_colliding():
		velocity = Vector3.ZERO
		var target = ray_cast_3d.get_collider()
		if target:
			if target.is_in_group("enemy"):
				print("enemy hit")
				target.hit()
		print("collding")
		collision_shape_3d.disabled = true
		mesh_instance_3d.visible = false
		gpu_particles_3d.emitting = true
		queue_free()
	else:
		velocity = transform.basis * Vector3(0, 0, -SPEED)
	move_and_collide(velocity * delta)
