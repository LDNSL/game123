extends Node3D
var hp = 3 
@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_3d: RayCast3D = $Armature/Skeleton3D/RayCast3D
@onready var eyes: Node3D = $eyes
@onready var shoottimer: Timer = $Timer

var target

const turning_speed = 64

enum {
	IDLE,
	ALERT,
	STUN,
}

var state = IDLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hp == 0:
		print("hit")
		queue_free()
	if ray_cast_3d.is_colliding():
		state = ALERT

	
	
	
	match state:
		IDLE:
			ap.play("Idle")
		ALERT:
			ap.play("Alert")
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(-deg_to_rad(eyes.rotation.y * turning_speed) * delta)
		STUN:
			ap.play("Stunned")


func _on_sight_range_body_entered(body: Node3D) -> void:
	print(body.get_groups())
	if body.is_in_group("player"):
		shoottimer.start()
		print("working")
		target = body
		state = ALERT


func _on_sight_range_body_exited(body: Node3D) -> void:
	state = IDLE
	shoottimer.stop()


func _on_timer_timeout() -> void:
	if ray_cast_3d.is_colliding():
		var hit = ray_cast_3d.get_collider()
		if hit.is_in_group("player"):
			print("hit")


func _on_area_3d_body_part_hit(dam: Variant) -> void:
	hp -= dam
	print("hit")
	if hp <= 0:
		queue_free()
