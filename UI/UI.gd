extends Control

func show_available_symms(i):
	#$VBoxContainer/HBoxContainer2/AvailableSymms.text = str(i)
	match i:
		0:
			$VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect1.visible = false
			$VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect2.visible = false
			$VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect3.visible = false
		1:
			$VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect1.visible = true
			$VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect2.visible = false
			$VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect3.visible = false
		2:
			$VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect1.visible = true
			$VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect2.visible = true
			$VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect3.visible = false
		3:
			$VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect1.visible = true
			$VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect2.visible = true
			$VBoxContainer/HBoxContainer2/VBoxContainer/TextureRect3.visible = true

var levels_done : int setget set_levels_done

func set_levels_done(_levels_done):
	levels_done = _levels_done
	var text = ""
	while true:
		if _levels_done > 5:
			text = text + str(5)
			_levels_done -= 5
		else:
			text = text + str(_levels_done)
			break
	$VBoxContainer/HBoxContainer/Striche.text = text
