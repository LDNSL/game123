extends Camera3D
@onready var fps_rig = $fps_rig
@onready var animation_player = $fps_rig/shotgun/AnimationPlayer
var shotgun_in_use = true

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
	if shotgun_in_use:
		if event.is_action_pressed("shoot"):
			animation_player.play("fire")
		if event.is_action_pressed("reload"):
			print("reload")
			animation_player.play("reload")
	if event.is_action_pressed("use"):
		shotgun_in_use = !shotgun_in_use
		if shotgun_in_use:
			animation_player.play("Pull_up")
		else:
			animation_player.play("Pull_DOWN")
	
