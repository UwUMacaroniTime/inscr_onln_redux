extends Button


# Called when the node enters the scene tree for the first time.
func _pressed():
	print("resetting")
	SettingsManager.settings = SettingsRes.new()
	SettingsManager.save_settings()
