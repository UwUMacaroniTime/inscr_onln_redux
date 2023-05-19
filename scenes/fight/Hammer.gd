extends Button

func _toggled(button_pressed):
	if Input.is_key_pressed(KEY_SHIFT): 
		# shift forces the button down.
		button_pressed = true

func _unhandled_input(event):
	if event is InputEventKey and event.physical_keycode == KEY_SHIFT:
		accept_event()
		button_pressed = event.pressed
