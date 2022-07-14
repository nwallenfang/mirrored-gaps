extends Control

func show_available_symms(i):
	#$VBoxContainer/HBoxContainer2/AvailableSymms.text = str(i)
	match i:
		0:
			$VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect1.visible = false
			$VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect2.visible = false
			$VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect3.visible = false
		1:
			$VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect1.visible = true
			$VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect2.visible = false
			$VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect3.visible = false
		2:
			$VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect1.visible = true
			$VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect2.visible = true
			$VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect3.visible = false
		3:
			$VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect1.visible = true
			$VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect2.visible = true
			$VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect3.visible = true


var levels_done : int setget set_levels_done
onready var group = get_node("%Group1")
onready var group_sizes = [8, 5, 5]
export var group1_color: Color
export var group2_color: Color
export var group3_color: Color
func set_levels_done(_levels_done):
	levels_done = _levels_done

	var group_sum = 0
	var index = 0
	for size in group_sizes:
		group_sum += size
		index += 1
		if levels_done < group_sum:
			match index:
				1:
					group.get_node("Progress").set("custom_colors/font_color", group1_color)
				2:
					group.get_node("Progress").set("custom_colors/font_color", group2_color)
				3:
					group.get_node("Progress").set("custom_colors/font_color", group3_color)
			break
	
	group.get_node("Progress").text = "%02d" % levels_done
	
	
#		if levels_this_group <= group_limit:
#			if group_limit >= 10:
#				group.get_node("Progress").text = "%02d" % levels_this_group
#			else:
#				group.get_node("Progress").text = "%d" % levels_this_group
#			return
#		else:
#			if group_limit >= 10:
#				group.get_node("Progress").text = "%02d" % group_limit
#			else:
#				group.get_node("Progress").text = "%d" % group_limit
#
##		levels_this_group -= group_limit
#	for group in groups:
#		group_limit = int(group.get_node("Limit").text.substr(1))
##		limit += group_limit
#
#		if levels_this_group <= group_limit:
#			if group_limit >= 10:
#				group.get_node("Progress").text = "%02d" % levels_this_group
#			else:
#				group.get_node("Progress").text = "%d" % levels_this_group
#			return
#		else:
#			if group_limit >= 10:
#				group.get_node("Progress").text = "%02d" % group_limit
#			else:
#				group.get_node("Progress").text = "%d" % group_limit
#
#		levels_this_group -= group_limit
#
#	printerr("shouldn't happen!! (set_levels_done)")
