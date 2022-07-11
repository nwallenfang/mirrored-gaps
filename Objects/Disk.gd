extends Spatial
class_name Disk

var speed := 5.0

func _physics_process(delta: float) -> void:
	self.global_transform.origin += speed * delta * Vector3.FORWARD

func get_image() -> Image:
	return $Sprite3D.texture.get_data()

func set_image(im: Image):
	var texture = ImageTexture.new()
	texture.create_from_image(im)
	$Sprite3D.texture = texture
	$Sprite3D.material_override.set("shader_param/texture_albedo", texture)

func discard():
	# TODO blend out
	yield(get_tree().create_timer(5.5), "timeout")
	queue_free()
