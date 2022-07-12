extends Spatial
class_name Disk

#var speed := 5.0
var number: int

func _physics_process(delta: float) -> void:
	self.global_transform.origin += Game.speed * delta * Vector3.FORWARD
	if Input.is_action_just_pressed("force_check"):
		check()

func get_image() -> Image:
	return $Sprite3D.texture.get_data()

func set_image(im):
	if im is StreamTexture:
		$Sprite3D.texture = im
		$Sprite3D.material_override.set("shader_param/texture_albedo", im)
		return
	var texture = ImageTexture.new()
	texture.create_from_image(im)
	$Sprite3D.texture = texture
	$Sprite3D.material_override.set("shader_param/texture_albedo", texture)

func load_disk_from_file(disk_number):
	var file_name = "res://Disks/" + str(disk_number) + ".png"
	var image_loaded = load(file_name)
	set_image(image_loaded)

func discard():
	#yield(get_tree().create_timer(1), "timeout")
	$Tween.interpolate_property($Sprite3D.material_override, "shader_param/albedo", Color.white, Color.transparent, 1.5)
	$Tween.start()
	yield(get_tree().create_timer(3.5), "timeout")
	queue_free()

var cross_origin := Vector2(256, 480)
var cross_radius := 28
func check():
	var im = get_image()
	var test_pixels = [cross_origin]
	for i in range(int(cross_radius/2)):
		test_pixels.append(cross_origin + 2*i*Vector2(0,1))
		test_pixels.append(cross_origin + 2*i*Vector2(0,-1))
		test_pixels.append(cross_origin + 2*i*Vector2(1,0))
		test_pixels.append(cross_origin + 2*i*Vector2(-1,0))
	for i in range(int(.7*cross_radius/2)):
		test_pixels.append(cross_origin + 2*i*Vector2(1,1))
		test_pixels.append(cross_origin + 2*i*Vector2(1,-1))
		test_pixels.append(cross_origin + 2*i*Vector2(-1,1))
		test_pixels.append(cross_origin + 2*i*Vector2(-1,-1))
	im.lock()
	for v in test_pixels:
		if im.get_pixelv(v) == Color.white:
			im.unlock()
			return false
	im.unlock()
	return true

