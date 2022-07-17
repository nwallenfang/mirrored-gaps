extends Spatial


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree().create_timer(1.0),"timeout")
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png("thumbnail.png")
