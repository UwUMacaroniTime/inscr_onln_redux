@icon("res://gfx/sigils/Stinky.png")
class_name Sigil_Stinky
extends Sigil

@export var amount:int = 1

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Stinky.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "Creatures that oppose this lose " + str(amount) + " attack."
	return super.get_desc().format([construct])
