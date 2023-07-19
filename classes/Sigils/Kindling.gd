@icon("res://gfx/sigils/Kindling.png")
class_name Sigil_Kindling
extends Sigil

@export var heat_gain:int = 2

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Kindling.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "When this card is discarded, owner gains %s heat instead of 1." % heat_gain
	
	return super.get_desc().format([construct])
