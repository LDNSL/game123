extends CanvasLayer

@onready var label: Label = $Control/Label
@onready var camera_3d: Camera3D = $"../neck/head/eyes/Camera3D"
@onready var viewport_cam: Camera3D = $SubViewportContainer/SubViewport/viewport_cam
@onready var shotgun: Node3D = $SubViewportContainer/SubViewport/viewport_cam/fps_rig/shotgun

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = str(shotgun.ammo) + "/" + str(shotgun.maxammo)
	viewport_cam.global_position = camera_3d.global_position
