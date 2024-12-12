extends Node3D
const bullet_speed = 40.0
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var timer: Timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -bullet_speed) * delta
	if ray_cast_3d.is_colliding():
		print("collding")
		mesh_instance_3d.visible = false
		gpu_particles_3d.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_timer_timeout():
	queue_free()
		
