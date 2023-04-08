extends Node2D

func _input(event):
		if event is InputEventKey:
			if event.pressed and event.scancode == KEY_ESCAPE:
					get_tree().change_scene("res://Scenes/Menu.tscn")
