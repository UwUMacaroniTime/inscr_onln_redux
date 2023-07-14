@icon("res://gfx/sigils/Waterborne.png")
class_name Sigil_Waterborne
extends Sigil

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Waterborne.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "This creature submerges during your opponent's turn. While submerged, this creature does not block enemy strikes."
	return super.get_desc().format([construct])
