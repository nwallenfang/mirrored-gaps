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

func set_levels_done(_levels_done):
	levels_done = _levels_done
	var text = ""
	while true:
		if len(text) > 4: text = text + "\n"
		if _levels_done > 5:
			text = text + str(5)
			_levels_done -= 5
		else:
			text = text + str(_levels_done)
			if len(text) <= 4: text = text + "\n"
			break
	$VBoxContainer/HBoxContainer/VBoxContainer/Container/HBoxContainer/Striche.text = text
