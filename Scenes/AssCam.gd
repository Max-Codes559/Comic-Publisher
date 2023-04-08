extends Camera2D

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				position.y -= 100
			if event.button_index == BUTTON_WHEEL_DOWN:
				position.y += 100
