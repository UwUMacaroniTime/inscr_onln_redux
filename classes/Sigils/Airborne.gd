class_name Sigil_Airborne
extends Sigil

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Airborne.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "While attacking, this strikes directly."
	return super.get_desc().format([construct])
