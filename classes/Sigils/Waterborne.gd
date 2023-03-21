class_name Sigil_Waterborne
extends Sigil

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Waterborne.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "This submerges during the opponent's turn. While submerged, opposing creatures attack this' owner directly."
	return super.get_desc().format([construct])
