extends CharacterBody3D
var hp = 3 
@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_3d: RayCast3D = $Armature/Skeleton3D/RayCast3D
var target
var gravity = 9.8
var motion = velocity
signal dummy_hit

const turning_speed = 64

enum {
	IDLE,
	ALERT,
	STUN,
}

var state = IDLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += -gravity * delta
	if hp == 0:
		print("hit")
		queue_free()
	move_and_slide()
		
func _on_timer_timeout() -> void:
	if ray_cast_3d.is_colliding():
		var hit = ray_cast_3d.get_collider()
		if hit.is_in_group("player"):
			print("hit")
func stun():
	print("stun")
	



func _on_area_3d_body_part_hit(dam: Variant) -> void:
	hp -= dam
	emit_signal("dummy_hit")
	if hp <= 0:
		queue_free()
func hit(damage):
	hp -= damage
	print("hit")
	if hp <= 0:
		queue_free()
