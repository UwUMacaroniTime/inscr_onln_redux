extends Node

var settings:SettingsRes
const file_loc = "user://settings.res"

func _ready():
	load_settings()

func load_settings():
	if FileAccess.file_exists(file_loc):
		print("found file!!")
		settings = load(file_loc)
		settings.resource_path = file_loc
	else:
		pass
		# fall back on default values
#		settings = SettingsRes.new()
	print(settings.default_deck)

func save_settings():
#	if not FileAccess.file_exists(file_loc):
	var _a := ResourceSaver.save(settings, file_loc, ResourceSaver.SaverFlags.FLAG_CHANGE_PATH)
	

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_settings()
