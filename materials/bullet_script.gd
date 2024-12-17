extends CharacterBody3D

@onready var bullet: CharacterBody3D = $"."

const SPEED = 75
const JUMP_VELOCITY = 4.5
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


func _physics_process(delta: float) -> void:
	velocity = transform.basis * Vector3(0, 0, -SPEED)
	 
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
		await get_tree().create_timer(1.0).timeout
		queue_free()
	move_and_collide(velocity * delta)
