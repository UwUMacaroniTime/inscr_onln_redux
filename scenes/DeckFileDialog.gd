extends FileDialog

signal save_as_signal

func _on_save_as_pressed():
	file_mode = FileDialog.FILE_MODE_SAVE_FILE
	popup_centered(size)

func _on_load_pressed():
	file_mode = FileDialog.FILE_MODE_OPEN_FILE
	popup_centered(size)
