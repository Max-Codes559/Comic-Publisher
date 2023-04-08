extends Node2D

func _ready():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Reading.tscn")

func _on_AssemblyButton_pressed():
	get_tree().change_scene("res://Scenes/Assembly.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()
