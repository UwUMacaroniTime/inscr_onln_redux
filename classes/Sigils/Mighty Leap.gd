class_name Sigil_MightyLeap
extends Sigil

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Mighty Leap.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "This blocks attacks from Airborne cards."
	return super.get_desc().format([construct])
