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
onready var groups = [get_node("%Group1"), get_node("%Group2"), get_node("%Group3")]
func set_levels_done(_levels_done):
	levels_done = _levels_done
	var limit = 0
	var group_limit
	var levels_this_group = levels_done
	for group in groups:
		group_limit = int(group.get_node("Limit").text.substr(1))
#		limit += group_limit
		
		if levels_this_group <= group_limit:
			if group_limit >= 10:
				group.get_node("Progress").text = "%02d" % levels_this_group
			else:
				group.get_node("Progress").text = "%d" % levels_this_group
			return
		else:
			if group_limit >= 10:
				group.get_node("Progress").text = "%02d" % group_limit
			else:
				group.get_node("Progress").text = "%d" % group_limit
			
		levels_this_group -= group_limit
			
	printerr("shouldn't happen!! (set_levels_done)")
	
	

#	$VBoxContainer/HBoxContainer/VBoxContainer/Container/HBoxContainer/Striche.text = text


#	while true:
#		if len(text) > 4: text = text + "\n"
#		if _levels_done > 5:
#			text = text + str(5)
#			_levels_done -= 5
#		else:
#			text = text + str(_levels_done)
#			if len(text) <= 4: text = text + "\n"
#			break
