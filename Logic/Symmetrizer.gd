extends Spatial

var selected_disk: Disk
var currently_symmetrizing = false

var number_of_frames = 20  # to spread the workload over
func calc_symm(im: Image, cursor: Vector2, rotation: float): #  -> Image:
	var res = Game.image_res#im.get_height()
#	print(Time.get_ticks_usec())
	var result : Image = Image.new()#im.duplicate(true)
	
	result.create(res, res, false, Image.FORMAT_RGBA8)
#	print(Time.get_ticks_usec())
	yield(get_tree(), "idle_frame")
#	yield(get_tree().create_timer(2.0), "timeout")
#	im.lock()
#	result.lock()
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
				var pos = Vector2(i, j)
				var mirrored = (pos - cursor).reflect(rotation_vec) + cursor
				if mirrored.x < Game.image_res-1 and mirrored.x > 0 and mirrored.y < Game.image_res-1 and mirrored.y > 0:
					result.set_pixel(int(mirrored.x), int(mirrored.y), Color.black)
					result.set_pixel(int(mirrored.x+1), int(mirrored.y), Color.black)
					result.set_pixel(int(mirrored.x-1), int(mirrored.y), Color.black)
					result.set_pixel(int(mirrored.x), int(mirrored.y+1), Color.black)
					result.set_pixel(int(mirrored.x), int(mirrored.y-1), Color.black)
		rows_this_frame += 1
	result.unlock()
	im.unlock()

	return result

func symmetrize_done(result):
	selected_disk.set_image(result)
	currently_symmetrizing = false

var cursor_speed_pixels := 300.0
var cursor_speed_rotation_degrees := 90.0
func _physics_process(delta):
	if selected_disk != null:
		self.global_transform.origin = selected_disk.global_transform.origin + Vector3(0.0, 0.0, -.5)
	if Input.is_action_pressed("cursor_move_up"):
		$Cursor.translation.y += cursor_speed_pixels * Game.meter_per_pixel * delta
	if Input.is_action_pressed("cursor_move_down"):
		$Cursor.translation.y -= cursor_speed_pixels * Game.meter_per_pixel * delta
	if Input.is_action_pressed("cursor_move_left"):
		$Cursor.translation.x += cursor_speed_pixels * Game.meter_per_pixel * delta
	if Input.is_action_pressed("cursor_move_right"):
		$Cursor.translation.x -= cursor_speed_pixels * Game.meter_per_pixel * delta
	if Input.is_action_pressed("cursor_rotate_clock"):
		$Cursor.rotation_degrees.z += cursor_speed_rotation_degrees * delta
	if Input.is_action_pressed("cursor_rotate_counter"):
		$Cursor.rotation_degrees.z -= cursor_speed_rotation_degrees * delta
	if Input.is_action_just_pressed("symmetrize"):
		# TODO only call calc_symm if there isn't an ongoing calc_symm at the moment
		if not currently_symmetrizing:
			var cursor_position_pixel = Vector2.ONE * Game.image_res * .5 + Vector2(-$Cursor.translation.x, -$Cursor.translation.y) / Game.meter_per_pixel
			var cursor_rotation_radians = deg2rad($Cursor.rotation_degrees.z)
			var image = selected_disk.get_image()
			var func_state = calc_symm(image, cursor_position_pixel, cursor_rotation_radians)
			func_state.connect("completed", self, "symmetrize_done")
			currently_symmetrizing = true

		#selected_disk.set_image(Image.new().create(512, 512, false, Image.FORMAT_RGBA8))

