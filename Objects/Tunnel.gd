extends Spatial


var default_muster_speed = 0.013
var speedup_muster_speed = 0.06

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Mesh.get_active_material(0).set("shader_param/scrolling_enabled", true)


func speedup_started():
	var floor_mat = $Floor.get_active_material(0)
	var tunnel_mat = $Mesh.get_active_material(0)
	$Tween.remove_all()
	$Tween.interpolate_property(floor_mat, "shader_param/symm_progress", 0.0, -0.9, 1.0)
#	$Tween.interpolate_property(tunnel_mat, "shader_param/muster_speed", default_muster_speed, speedup_muster_speed, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	tunnel_mat.set("shader_param/muster_speed", speedup_muster_speed)
	$Tween.start()
	
func speedup_stopped():
	var tunnel_mat = $Mesh.get_active_material(0)
#	$Tween.remove_all()
#	$Tween.interpolate_property(tunnel_mat, "shader_param/muster_speed", speedup_muster_speed, default_muster_speed, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.start()
#	tunnel_mat.set("shader_param/muster_speed", default_muster_speed)
