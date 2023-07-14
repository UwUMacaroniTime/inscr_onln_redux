@icon("res://gfx/sigils/Double Strike.png")
class_name Sigil_DoubleStrike
extends Sigil

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Double Strike.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "While attacking, this creature strikes forward an additional time."
	return super.get_desc().format([construct])
