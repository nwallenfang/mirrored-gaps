extends Spatial


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Animation.play("Roll")

func destroy_animation():
	$Mesh.visible = false
	$Particles.emitting = true

func reset_destruction():
	$Mesh.visible = true
	$Particles.emmitting = false


func show_symmetrizes_left(number: int):
	if number == 0:
		$SymmetrizesLeft.visible = false
	else:
		$SymmetrizesLeft.visible = true
		$SymmetrizesLeft.text = str(number)
