extends CharacterBody3D

@onready var bullet: CharacterBody3D = $"."

const SPEED = 480.00
const JUMP_VELOCITY = 4.5
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


func _physics_process(delta: float) -> void:
	velocity = transform.basis * Vector3(0, 0, -SPEED)
	var collision = move_and_collide(velocity * delta)
	if collision:
		print("collding")
		mesh_instance_3d.visible = false
		gpu_particles_3d.emitting = true 
		await get_tree().create_timer(1.0).timeout
		queue_free()
