extends Spatial

export var speed = 80.0  # meter / second

const DISK = preload("res://Objects/Disk.tscn")

func _ready() -> void:
	$Tunnel.get_node("Mesh").get_active_material(0).set("shader_param/scroll_speed", speed)
	
	
	var disk = DISK.instance()
	disk.speed = speed
	$Disks.add_child(disk)
	disk.global_transform.origin = $DiskSpawnPosition.global_transform.origin
	
	Game.symmetrizer = $Symmetrizer


func _on_SpawnDiskTimer_timeout() -> void:
	var disk = DISK.instance()
	disk.speed = speed
	$Disks.add_child(disk)
	disk.global_transform.origin = $DiskSpawnPosition.global_transform.origin

