extends Control

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
	$HBoxContainer/Striche.text = text
