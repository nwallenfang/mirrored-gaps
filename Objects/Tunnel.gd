extends Spatial


var default_muster_speed = 0.013
var speedup_muster_speed = 0.06

export var group1_color: Color
export var group1_color_bg: Color
export var group2_color: Color
export var group2_color_bg: Color
export var group3_color: Color
export var group3_color_bg: Color
export var group4_color: Color
export var group4_color_bg: Color
var current_color: Color
var current_color_bg: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Mesh.get_active_material(0).set("shader_param/scrolling_enabled", true)
	set_color_without_transition(1 if not Game.hard_levels else 4)

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

func get_color_from_group_number(group_number: int, bg: bool):
	match(group_number):
		1:
			return group1_color_bg if bg else group1_color
		2:
			return group2_color_bg if bg else group2_color
		3:
			return group3_color_bg if bg else group3_color
		4:
			return group4_color_bg if bg else group4_color

func set_color_with_transition(group_number: int):
	$Tween.interpolate_property($Mesh.get("material/0"), "shader_param/tunnel_color1", current_color, get_color_from_group_number(group_number, false), 1.5)
	$Tween.interpolate_property($Mesh.get("material/0"), "shader_param/tunnel_color2", current_color_bg, get_color_from_group_number(group_number, true), 1.5)
	$Tween.start()
	current_color = get_color_from_group_number(group_number, false)
	current_color_bg = get_color_from_group_number(group_number, true)

func set_color_without_transition(group_number: int):
	current_color = get_color_from_group_number(group_number, false)
	current_color_bg = get_color_from_group_number(group_number, true)
	$Mesh.get("material/0").set("shader_param/tunnel_color1", current_color)
	$Mesh.get("material/0").set("shader_param/tunnel_color2", current_color_bg)
