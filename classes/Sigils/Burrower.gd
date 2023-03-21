class_name Sigil_Burrower
extends Sigil

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Burrower.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "When an enemy card would strike directly, this will attempt to block it."
	return super.get_desc().format([construct])
