extends Spatial


func _ready() -> void:
	$Animation.play("Roll")
	set_roll_speed(1.5)

func destroy_animation():
	$CollisionSound.play()
	$Mesh.visible = false
	$Particles.emitting = true

func reset_destruction():
	$Mesh.visible = true
	$Particles.emmitting = false

func set_roll_speed(s):
	$Animation.playback_speed = s

func show_symmetrizes_left(number: int):
	if number == 0:
		$SymmetrizesLeft.visible = false
	else:
		$SymmetrizesLeft.visible = true
		$SymmetrizesLeft.text = str(number)
