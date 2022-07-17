extends Spatial

var selected_disk: Disk
var currently_symmetrizing := false

var victory_animation := false

onready var cursor = $Cursor

var number_of_frames = 30  # to spread the workload over
func calc_symm(im: Image, cursor_pos: Vector2, rotation: float): #  -> Image:
	var res = Game.image_res

	var result : Image = Image.new()
	
	result.create(res, res, false, Image.FORMAT_L8)

	yield(get_tree(), "idle_frame")

	var rotation_vec := Vector2.LEFT.rotated(rotation)
	var rows_this_frame = 0
	var rows_per_frame = int(res/number_of_frames)
	
	result.fill(Color.white)
	yield(get_tree(), "idle_frame")
	im.lock()
	result.lock()

	for i in range(res):
		if rows_this_frame >= rows_per_frame:
			rows_this_frame = 0
			yield(get_tree(), "idle_frame")
		for j in range(res):
			if im.get_pixel(i, j) == Color.black:
				result.set_pixel(i, j, Color.black)
				if i < Game.image_res-1 and i > 0 and j < Game.image_res-1 and j > 0:
					result.set_pixel(i+1, j+1, Color.black)
					result.set_pixel(i+1, j, Color.black)
					result.set_pixel(i+1, j-1, Color.black)
					result.set_pixel(i, j+1, Color.black)
					result.set_pixel(i, j-1, Color.black)
					result.set_pixel(i-1, j+1, Color.black)
					result.set_pixel(i-1, j, Color.black)
					result.set_pixel(i-1, j-1, Color.black)
				var pos = Vector2(i, j)
				var mirrored = (pos - cursor_pos).reflect(rotation_vec) + cursor_pos
				var mirrored_x = int(mirrored.x)
				var mirrored_y = int(mirrored.y)
				
				if mirrored_x < Game.image_res-1 and mirrored_x > 0 and mirrored_y < Game.image_res-1 and mirrored_y > 0:
					result.set_pixel(mirrored_x, mirrored_y, Color.black)
					result.set_pixel(mirrored_x + 1, mirrored_y, Color.black)
					result.set_pixel(mirrored_x - 1, mirrored_y, Color.black)
					result.set_pixel(mirrored_x, mirrored_y + 1, Color.black)
					result.set_pixel(mirrored_x, mirrored_y - 1, Color.black)
					result.set_pixel(mirrored_x - 1, mirrored_y - 1, Color.black)
					result.set_pixel(mirrored_x + 1, mirrored_y - 1, Color.black)
					result.set_pixel(mirrored_x - 1, mirrored_y + 1, Color.black)
					result.set_pixel(mirrored_x + 1, mirrored_y + 1, Color.black)

		rows_this_frame += 1
	result.unlock()
	im.unlock()

	return result

func symmetrize_done(result):
	#selected_disk.set_image(result)
	selected_disk.splash_end(result)
	yield(get_tree().create_timer(.3),"timeout")
	currently_symmetrizing = false

var cursor_speed_pixels := 180.0
var cursor_speed_rotation_degrees := 72.0
var cursor_max_distance := 12.2
func _physics_process(delta):
	if victory_animation:
		$Cursor.translation.z = 6.0 + sin((Time.get_ticks_msec() / 1000.0) * 2.0) * 5.0
		print($Cursor.translation.z)
	if selected_disk != null:
		self.global_transform.origin = selected_disk.global_transform.origin + Vector3(0.0, 0.0, -.5)
	if Game.can_move and not currently_symmetrizing:
		if Input.is_action_pressed("cursor_move_up"):
			$Cursor.translation.y += cursor_speed_pixels * Game.meter_per_pixel * delta
		if Input.is_action_pressed("cursor_move_down"):
			$Cursor.translation.y -= cursor_speed_pixels * Game.meter_per_pixel * delta
		if Input.is_action_pressed("cursor_move_left"):
			$Cursor.translation.x += cursor_speed_pixels * Game.meter_per_pixel * delta
		if Input.is_action_pressed("cursor_move_right"):
			$Cursor.translation.x -= cursor_speed_pixels * Game.meter_per_pixel * delta
	if Game.can_rotate and not currently_symmetrizing:
		if Input.is_action_pressed("cursor_rotate_clock"):
			$Cursor.rotation_degrees.z += cursor_speed_rotation_degrees * delta
		if Input.is_action_pressed("cursor_rotate_counter"):
			$Cursor.rotation_degrees.z -= cursor_speed_rotation_degrees * delta
	if $Cursor.translation.length() > cursor_max_distance:
		$Cursor.translation *= cursor_max_distance / $Cursor.translation.length()
	if Input.is_action_just_pressed("symmetrize"):
		if (not currently_symmetrizing) and is_instance_valid(selected_disk):
			if Game.available_symms > 0:
				var cursor_position_pixel = Vector2.ONE * Game.image_res * .5 + Vector2(-$Cursor.translation.x, -$Cursor.translation.y) / Game.meter_per_pixel
				var cursor_rotation_radians = deg2rad($Cursor.rotation_degrees.z)
				var image = selected_disk.get_image()
				var func_state = calc_symm(image, cursor_position_pixel, cursor_rotation_radians)
				selected_disk.splash_start(cursor_position_pixel, cursor_rotation_radians)
				func_state.connect("completed", self, "symmetrize_done")
				currently_symmetrizing = true

				Game.tunnel.speedup_started()
				Game.available_symms -= 1

