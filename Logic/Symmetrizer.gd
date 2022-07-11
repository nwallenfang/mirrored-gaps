extends Spatial


func _ready():
	pass


func calc_symm(im: Image, cursor: Vector2, rotation: float) -> Image:
	var res := im.get_height()
	var result : Image = im.duplicate(true)
	var rotation_vec := Vector2.LEFT.rotated(rotation)
	for i in range(res):
		for j in range(res):
			var pos = Vector2(i, j)
			var mirrored = (pos - cursor).reflect(rotation_vec) + cursor
			if im.get_pixel(int(mirrored.x), int(mirrored.y)) == Color.black:
				result.set_pixel(i, j, Color.black)
	return result

var cursor_speed_pixels
func _physics_process(delta):
	if Input.is_action_pressed("cursor_move_up"):
		pass
	if Input.is_action_pressed("cursor_move_down"):
		pass
	if Input.is_action_pressed("cursor_move_left"):
		pass
	if Input.is_action_pressed("cursor_move_right"):
		pass
	if Input.is_action_pressed("cursor_rotate_clock"):
		pass
	if Input.is_action_pressed("cursor_rotate_counter"):
		pass
