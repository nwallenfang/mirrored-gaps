extends Spatial

var selected_disk: Disk

func calc_symm(im: Image, cursor: Vector2, rotation: float) -> Image:
	var res = Game.image_res#im.get_height()
	var result : Image = im.duplicate(true)
	var rotation_vec := Vector2.LEFT.rotated(rotation)
	for i in range(res):
		for j in range(res):
			var pos = Vector2(i, j)
			var mirrored = (pos - cursor).reflect(rotation_vec) + cursor
			if im.get_pixel(int(mirrored.x), int(mirrored.y)) == Color.black:
				result.set_pixel(i, j, Color.black)
	return result

var cursor_speed_pixels := 300.0
var cursor_speed_rotation_degrees := 90.0
func _physics_process(delta):
	if selected_disk != null:
		self.global_transform.origin = selected_disk.global_transform.origin
	if Input.is_action_pressed("cursor_move_up"):
		$Cursor.translation.y += cursor_speed_pixels * Game.meter_per_pixel * delta
	if Input.is_action_pressed("cursor_move_down"):
		$Cursor.translation.y -= cursor_speed_pixels * Game.meter_per_pixel * delta
	if Input.is_action_pressed("cursor_move_left"):
		$Cursor.translation.x -= cursor_speed_pixels * Game.meter_per_pixel * delta
	if Input.is_action_pressed("cursor_move_right"):
		$Cursor.translation.x += cursor_speed_pixels * Game.meter_per_pixel * delta
	if Input.is_action_pressed("cursor_rotate_clock"):
		$Cursor.rotation_degrees.z += cursor_speed_rotation_degrees * delta
	if Input.is_action_pressed("cursor_rotate_counter"):
		$Cursor.rotation_degrees.z -= cursor_speed_rotation_degrees * delta
	if Input.is_action_just_pressed("symmetrize"):
		var cursor_position_pixel = Vector2.ONE * Game.image_res * .5 + Vector2($Cursor.translation.x, $Cursor.translation.y) / Game.meter_per_pixel
		var cursor_rotation_radians = deg2rad($Cursor.rotation_degrees.z)
		selected_disk.set_image(calc_symm(selected_disk.get_image(), cursor_position_pixel, cursor_rotation_radians))

