extends Node

var meter_per_pixel := 27.782/512.0
var tube_scale := 27.782
var image_res := 512
var disk_number = 1

var hard_levels := false
var level_count := 18 setget , get_level_count
func get_level_count() -> int:
	return level_count if not hard_levels else 10

var current_disk : Disk setget set_current_disk
var sphere: Node
var symmetrizer
var tunnel
var ui
var speed_lines

var speed := 12.0 # meter / second
var speed_backup := -1.0
var start_speed := 7.0
var accel := 0.0#.7

var current_tries := 0

var speedup_speed = 65.0
var super_speedup_speed = 110.0
var speedup_active = false setget set_speedup_active

var tutorials := {
	1: "Press SPACE\nto create symmetry",
	2: "Press Q/E\nto rotate the axis",
	9: "Press WASD\nto move the axis",
	14: "Sometimes you\ncan symmetrize\nmore than once"
}

var hard_tutorials := {
	1: "So you want more?",
}

func _ready() -> void:
	# wait for a bit before starting music
	pass


func initial_main_theme_start():
	$MainTheme1.play()
#	$SoundTween.reset_all()
#	$SoundTween.interpolate_property($MainTheme1, "volume_db", -80, -10, 1.0)
#	$SoundTween.start()
	
func switch_to_second_theme():
	$SoundTween.reset_all()
	$SoundTween.interpolate_property($MainTheme1, "volume_db", -10, -80, 2.0)
	$SoundTween.interpolate_property($MainTheme2, "volume_db", -45, -10, 2.0)
	$SoundTween.start()
	$MainTheme2.play()
	yield($SoundTween, "tween_all_completed")
	$MainTheme1.stop()

var level_data_dict := { #symm count, can_rotate, can_move, cursor_reset_location, cursor_reset_rotation
	1: [1, false, false, null, null],
	2: [1, true, false, null, null],
	3: [1, true, false, null, null],
	4: [1, true, false, null, null],
	5: [1, true, false, null, null],
	6: [1, true, false, null, null],
	7: [1, true, false, null, null],
	8: [1, true, false, null, null],
	9: [1, true, true, null, null],
	10: [1, true, true, null, null],
	11: [1, true, true, null, null],
	12: [1, true, true, null, null],
	13: [1, true, true, null, null],
	14: [2, true, true, null, null],
	15: [2, true, true, null, null],
	16: [2, true, true, null, null],
	17: [3, true, true, null, null],
	18: [1, true, true, null, null],
}

var hard_level_data_dict := { #symm count, can_rotate, can_move, cursor_reset_location, cursor_reset_rotation
	1: [1, true, true, null, null],
	2: [1, true, true, null, null],
	3: [1, true, true, null, null],
	4: [1, true, true, null, null],
	5: [1, true, true, null, null],
	6: [1, true, true, null, null],
	7: [1, true, true, null, null],
	8: [2, true, true, null, null],
	9: [1, true, true, null, null],
	10: [3, true, true, null, null],
}

var available_symms: int setget set_available_symms
var can_rotate := false
var can_move := false

func set_available_symms(x):
	available_symms = x
#	ui.show_available_symms(x)
	if x >= 2:
		sphere.multi_sym_started = true
	sphere.show_symmetrizes_left(x)
	if x == 0:
		can_move = false
		can_rotate = false
		self.speedup_active = true
	else:
		self.speedup_active = false

func set_current_disk(disk: Disk):
	current_disk = disk
	if symmetrizer != null:
		symmetrizer.selected_disk = disk
	if disk == null:
		return
	var level_data
	if not hard_levels:
		level_data = level_data_dict[disk.number]
	else:
		level_data = hard_level_data_dict[disk.number]
	self.available_symms = level_data[0]
	can_rotate = level_data[1]
	can_move = level_data[2]
	if level_data[3] != null:
		symmetrizer.cursor.translation = level_data[3]
	if level_data[4] != null:
		symmetrizer.cursor.rotation_degrees.z = level_data[4]
		
func set_speedup_active(active: bool):
	if active != speedup_active:
		if active:
			speed_backup = Game.speed
			$Tween.remove_all()
			$Tween.interpolate_property(self, "speed", speed, speedup_speed if current_tries < 2 else super_speedup_speed, 1.7, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
			$Tween.interpolate_property(self.speed_lines.get_node("MeshInstance").material_override, "shader_param/albedo", Color.transparent, Color.white, 1.5)
			$Tween.interpolate_method(sphere, "set_roll_speed", 1.5, 4.0, 1.0)
			$Tween.start()
			var pitch_strength = 0.1
			AudioServer.get_bus_effect(1, 1).wet = 0.3 + ((randf() - 0.5) * pitch_strength)
			$SpeedupSound.play()
			
		else:
			$Tween.remove_all()
			$Tween.interpolate_property(self, "speed", speed, start_speed, 0.8, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
			$Tween.interpolate_property(self.speed_lines.get_node("MeshInstance").material_override, "shader_param/albedo", Color.white, Color.transparent, .8)
			$Tween.interpolate_method(sphere, "set_roll_speed", 4.0, 1.5, 1.0)
			$Tween.start()
			tunnel.speedup_stopped()

	speedup_active = active

func stop_speedlines_fast():
	if speedup_active:
		speedup_active = false
		$Tween.remove_all()
		$Tween.interpolate_property(self.speed_lines.get_node("MeshInstance").material_override, "shader_param/albedo", Color.white, Color.transparent, .3)
		$Tween.start()

