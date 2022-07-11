extends Spatial

export var speed = 10.0  # meter / second

const DISK = preload("res://Objects/Disk.tscn")

func _ready() -> void:
	$Tunnel.get_node("Mesh").get_active_material(0).set("shader_param/scroll_speed", speed)
	
	
	spawn_disk()
	
	Game.symmetrizer = $Symmetrizer

func spawn_disk():
	var disk = DISK.instance()
	disk.speed = speed
	disk.name = "Disk" + str(Game.disk_number)
	Game.disk_number += 1
	$Disks.add_child(disk)
	disk.global_transform.origin = $DiskSpawnPosition.global_transform.origin
	if Game.current_disk == null:
		Game.current_disk = disk


func _on_SpawnDiskTimer_timeout() -> void:
	spawn_disk()


func _on_DiskDetectionArea_area_entered(area:Area) -> void:
	var disk = area.get_parent()
	assert(disk is Disk)
	
	if $Disks.get_child_count() == 1:
		print('no new disk to set')
		Game.current_disk = null
	else:
		Game.current_disk = $Disks.get_child(1)
		
	disk.discard()

