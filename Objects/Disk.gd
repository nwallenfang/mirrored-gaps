extends Spatial

var speed := 5.0

func _physics_process(delta: float) -> void:
	self.global_transform.origin += speed * delta * Vector3.FORWARD
