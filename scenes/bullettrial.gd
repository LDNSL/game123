extends MeshInstance3D

var bullet_alpha = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var duplicate_overide= material_override.duplicate()
	material_override = duplicate_overide

func init(pos1, pos2):
	var muzzle = pos1
	var draw_mesh = ImmediateMesh.new()
	mesh = draw_mesh
	draw_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material_override)
	draw_mesh.surface_add_vertex(pos1)
	draw_mesh.surface_add_vertex(pos2)
	draw_mesh.surface_end()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	bullet_alpha -= delta* 3.5
	material_override.albedo_color.a = bullet_alpha


func _on_timer_timeout() -> void:
	queue_free()
