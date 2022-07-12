extends Spatial

var default_distance := 450.0
func initialize(disk, text):
	$Label3D.text = text
	disk.add_child(self)
	self.translation.z = -default_distance
