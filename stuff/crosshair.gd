extends SubViewportContainer
@onready var crosshair: TextureRect = $"SubViewport/normal cross"
@onready var hit_cross_hair: TextureRect = $"SubViewport/hit cross hair"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_cross_hair.visible = false
	crosshair.visible = true
	crosshair.position.x = get_viewport().size.x / 2 -32
	crosshair.position.y = get_viewport().size.y / 2 -32
	hit_cross_hair.position.x = get_viewport().size.x / 2 -32
	hit_cross_hair.position.y = get_viewport().size.y / 2 -32
	
func _hitmarker():
	hit_cross_hair.visible = true 
	await get_tree().create_timer(0.05).timeout
	hit_cross_hair.visible = false
