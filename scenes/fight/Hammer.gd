extends Button

func _toggled(_button_pressed):
	if Input.is_key_pressed(KEY_SHIFT): 
		# shift forces the button down.
		button_pressed = true
	udate_hammer_cur()
	

func _unhandled_input(event):
	if event is InputEventKey and event.physical_keycode == KEY_SHIFT:
		accept_event()
		if button_pressed != event.pressed:
			button_pressed = event.pressed
			udate_hammer_cur()

## update the hammer cursor.
func udate_hammer_cur():
	if button_pressed:
		CursorManager.cur_cursor = preload("res://gfx/extra/mouse/cursor_data/Hammer.tres")
	else:
		CursorManager.cur_cursor = preload("res://gfx/extra/mouse/cursor_data/Pointer.tres")

func udate():
	tooltip_text = "Hammer - Use to destroy cards on your side of the field, or discard cards in your hand.
Hammer Smashes Left this turn: {0}".format([Battlemanager.players[0].hammer_smashes])
	button_pressed = Battlemanager.players[0].hammer_smashes > 0
	disabled = Battlemanager.players[0].hammer_smashes == 0
	text = "(" + str(Battlemanager.players[0].hammer_smashes) + "/" + str(Battlemanager.base_hammer_smashes) + ")"
