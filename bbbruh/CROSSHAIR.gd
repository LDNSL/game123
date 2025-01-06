extends SubViewportContainer
@onready var crosshair = $"SubViewport/normal cross"
@onready var hit_cross_hair = $"SubViewport/hit cross hair"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_cross_hair.visible = false
	crosshair.position.x = get_viewport().size.x / 2 -32
	crosshair.position.y = get_viewport().size.y / 2 -32
	hit_cross_hair.position.x = get_viewport().size.x / 2 -32
	hit_cross_hair.position.y = get_viewport().size.y / 2 -32


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _hitmarker():
	hit_cross_hair.visible = true 
	await get_tree().create_timer(0.05).timeout
	hit_cross_hair.visible = false
