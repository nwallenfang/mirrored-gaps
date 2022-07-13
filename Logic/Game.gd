extends Node

var meter_per_pixel := 27.782/512.0
var tube_scale := 27.782
var image_res := 512
var disk_number = 1

var level_count = 20

var current_disk : Disk setget set_current_disk
var symmetrizer
var tunnel
var ui
var speed_lines

var speed := 12.0 # meter / second
var speed_backup := -1.0
var start_speed := 8.0
var accel := 0.0#.7

var speedup_speed = 65.0
var speedup_active = false setget set_speedup_active

var tutorials := {
	1: "Press SPACE\nto create symmetry",
	2: "Press Q/E\nto rotate the axis",
	9: "Press WASD\nto move the axis",
	13: "Sometimes you need\nto symmetrize\nmore than once"
}

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
	13: [2, true, true, null, null],
	14: [3, true, true, null, null],
	15: [3, true, true, null, null],
	16: [2, true, true, null, null],
	17: [2, true, true, null, null],
	18: [3, true, true, null, null],
	19: [3, true, true, null, null],
	20: [1, true, true, null, null],
}

var number_of_levels_per_group = [8, 6, 14]

var available_symms: int setget set_available_symms
var can_rotate := false
var can_move := false

func set_available_symms(x):
	available_symms = x
	ui.show_available_symms(x)
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
	var level_data = level_data_dict[disk.number]
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
			#print($Tween)
			$Tween.remove_all()
			$Tween.interpolate_property(self, "speed", speed, speedup_speed, 1.7)
			$Tween.interpolate_property(self.speed_lines.get_node("MeshInstance").material_override, "shader_param/albedo", Color.transparent, Color.white, 1.5)
			$Tween.start()
	#		speed = Game.speedup_speed
		else:
			$Tween.remove_all()
			$Tween.interpolate_property(self, "speed", speed, start_speed, 0.8)
			$Tween.interpolate_property(self.speed_lines.get_node("MeshInstance").material_override, "shader_param/albedo", Color.white, Color.transparent, .6)
			$Tween.start()
	#		speed = Game.speed_backup

	speedup_active = active
	
	
