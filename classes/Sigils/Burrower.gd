@icon("res://gfx/sigils/Burrower.png")
class_name Sigil_Burrower
extends Sigil

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Burrower.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "When an enemy creature would strike directly, this creature moves to block it. (if able)"
	return super.get_desc().format([construct])
