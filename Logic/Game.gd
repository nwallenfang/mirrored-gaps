extends Node

var meter_per_pixel := 27.782/512.0
var image_res := 512
var disk_number = 1

var current_disk : Disk setget set_current_disk
var symmetrizer

func _ready() -> void:
	pass 

func set_current_disk(disk: Disk):
	current_disk = disk
	if symmetrizer != null:
		symmetrizer.selected_disk = disk
