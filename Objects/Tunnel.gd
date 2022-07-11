extends Spatial




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Mesh.get_active_material(0).set("shader_param/scrolling_enabled", true)
