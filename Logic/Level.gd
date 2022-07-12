extends Spatial

#export var speed = 12.0  # meter / second

const DISK = preload("res://Objects/Disk.tscn")

func _ready() -> void:
	Game.tunnel = $Tunnel
	Game.symmetrizer = $Symmetrizer	
	spawn_disk()

func spawn_disk():
	var disk = DISK.instance()
	disk.number = Game.disk_number
	disk.name = "Disk" + str(Game.disk_number)
	disk.load_disk_from_file(Game.disk_number)
	Game.disk_number += 1
	$Disks.add_child(disk)
	disk.global_transform.origin = $DiskSpawnPosition.global_transform.origin
	if Game.current_disk == null:
		Game.current_disk = disk


func _on_SpawnDiskTimer_timeout() -> void:
	if Game.disk_number <= Game.level_count:
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
	
	if not disk.check():
		var killer_disk_number = disk.number
		$Sphere.destroy_animation()
		#$Tween.interpolate_property(Game, "speed", Game.speed, 0.0, 3.0,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		#$Tween.start()
		yield(get_tree().create_timer(3),"timeout")
		Game.disk_number = killer_disk_number
		Game.current_disk = null
		get_tree().change_scene("res://Logic/Level.tscn")
	else:
		if disk.number == Game.level_count:
			$WinText.visible = true

