extends Node

var settings:SettingsRes
const file_loc = "user://settings.res"

func _ready():
	load_settings()

func load_settings():
	if FileAccess.file_exists(file_loc):
		print("Settings found.")
		settings = load(file_loc)
		settings.resource_path = file_loc
		if settings == null: # something has happened
			print("Error while loading settings, reverting to default values.")
			settings = SettingsRes.new()
	else:
		print("No settings found, reverting to default values.")
		# fall back on default values
		settings = SettingsRes.new()

func save_settings():
#	if not FileAccess.file_exists(file_loc):
	var _a := ResourceSaver.save(settings, file_loc, ResourceSaver.SaverFlags.FLAG_CHANGE_PATH)
	

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_settings()
