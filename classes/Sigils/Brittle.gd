@icon("res://gfx/sigils/Brittle.png")
class_name Sigil_Brittle
extends Sigil

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Brittle.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "After this creature attacks, it perishes."
	return super.get_desc().format([construct])
