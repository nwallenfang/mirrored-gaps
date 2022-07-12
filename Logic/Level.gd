extends Spatial

#export var speed = 12.0  # meter / second

const DISK = preload("res://Objects/Disk.tscn")
const TUTORIAL = preload("res://Objects/Tutorial.tscn")

func _ready() -> void:
	Game.tunnel = $Tunnel
	Game.symmetrizer = $Symmetrizer
	Game.ui = $UI
	Game.speed = Game.start_speed

var spawn_dist := 140.0
var next_spawn := 0.0
var tunnel_dist = 0.0
func _process(delta):
	tunnel_dist += delta * Game.speed
	$Tunnel.get_node("Mesh").get_active_material(0).set("shader_param/distance_travelled", tunnel_dist)
	Game.speed += delta * Game.accel
	if tunnel_dist > next_spawn:
		next_spawn += spawn_dist
		spawn_disk()

func spawn_disk():
	if Game.disk_number > Game.level_count:
		return
	var disk = DISK.instance()
	disk.number = Game.disk_number
	disk.name = "Disk" + str(Game.disk_number)
	disk.load_disk_from_file(Game.disk_number)
	Game.disk_number += 1
	$Disks.add_child(disk)
	disk.global_transform.origin = $DiskSpawnPosition.global_transform.origin
	if disk.number in Game.tutorials:
		var tutorial = TUTORIAL.instance()
		tutorial.initialize(disk, Game.tutorials[disk.number])
	if Game.current_disk == null:
		Game.current_disk = disk
		if $UI.levels_done == 0:
			$UI.set_levels_done(disk.number-1)

func _on_DiskDetectionArea_area_entered(area:Area) -> void:
	var disk = area.get_parent()
	assert(disk is Disk)

	disk.discard()
	
	if not disk.check(): # if collision crash
		var killer_disk_number = disk.number
		$Sphere.destroy_animation()
		$Tween.interpolate_property(Game, "speed", Game.speed, 0.0, 2.0)
		$Tween.start()
		yield(get_tree().create_timer(3),"timeout")
		Game.disk_number = killer_disk_number
		Game.current_disk = null
		get_tree().change_scene("res://Logic/Level.tscn")
	else:
		if $Disks.get_child_count() == 1:
			print('no new disk to set')
			Game.current_disk = null
		else:
			Game.current_disk = $Disks.get_child(1)
		$UI.set_levels_done(disk.number)
		if disk.number == Game.level_count:
			$WinText.visible = true
			$Symmetrizer.selected_disk = null
			$Symmetrizer.global_transform.origin.z = $WinText.global_transform.origin.z + 1
			Game.can_rotate = true
			Game.can_move = true

func _on_AutoSymmArea_area_entered(area):
	pass # Replace with function body.
