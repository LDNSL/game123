extends Node3D
var hp = 3 
@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_3d: RayCast3D = $Armature/Skeleton3D/RayCast3D
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
		
func _on_timer_timeout() -> void:
	if ray_cast_3d.is_colliding():
		var hit = ray_cast_3d.get_collider()
		if hit.is_in_group("player"):
			print("hit")
func stun():
	print("stun")


func _on_area_3d_body_part_hit(dam: Variant) -> void:
	hp -= dam
	print("hit")
	if hp <= 0:
		queue_free()
func hit(damage):
	hp -= damage
	print("hit")
	if hp <= 0:
		queue_free()
