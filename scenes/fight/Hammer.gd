extends Button

func _toggled(button_pressed):
	if Input.is_key_pressed(KEY_SHIFT): 
		# shift forces the button down.
		button_pressed = true

func _unhandled_input(event):
	if event is InputEventKey and event.physical_keycode == KEY_SHIFT:
		accept_event()
		button_pressed = event.pressed

func udate():
	tooltip_text = "Hammer - Use to destroy cards on your side of the field, or discard cards in your hand.
Hammer Smashes Left this turn: {0}".format([Battlemanager.players[0].hammer_smashes])
	button_pressed = Battlemanager.players[0].hammer_smashes > 0
	disabled = Battlemanager.players[0].hammer_smashes == 0
	text = "(" + str(Battlemanager.players[0].hammer_smashes) + "/" + str(Battlemanager.base_hammer_smashes) + ")"
