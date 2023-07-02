extends Node2D

var cur_cursor:Cursor = preload("res://gfx/extra/mouse/cursor_data/Pointer.tres"):
	set(value):
		#Input.warp_mouse(get_global_mouse_position() - cur_cursor.hotspot + value.hotspot)
		cur_cursor = value
		change_cursor()

func change_cursor():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_custom_mouse_cursor(cur_cursor.click, cur_cursor.mouse_type, cur_cursor.hotspot)
		return
	Input.set_custom_mouse_cursor(cur_cursor.norm, cur_cursor.mouse_type, cur_cursor.hotspot)

func _input(event):
	if event is InputEventMouseButton:
		change_cursor()
