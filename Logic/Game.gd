extends Node

var meter_per_pixel := 27.782/512.0
var tube_scale := 27.782
var image_res := 512
var disk_number = 1

var level_count = 4

var current_disk : Disk setget set_current_disk
var symmetrizer
var tunnel

var speed := 12.0 # meter / second
var start_speed := 12.0
var accel := .7

func _ready() -> void:
	pass 

func set_current_disk(disk: Disk):
	current_disk = disk
	if symmetrizer != null:
		yield(get_tree().create_timer(.5),"timeout")
		symmetrizer.selected_disk = disk
