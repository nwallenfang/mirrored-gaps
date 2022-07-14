extends Spatial




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Mesh.get_active_material(0).set("shader_param/scrolling_enabled", true)


func speedup_started():
	var floor_mat = $Floor.get_active_material(0)
	$Tween.remove_all()
	$Tween.interpolate_property(floor_mat, "shader_param/symm_progress", 0.0, -0.9, 1.0)
	$Tween.start()
