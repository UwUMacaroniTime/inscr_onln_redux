@icon("res://gfx/sigils/Guardian.png")
class_name Sigil_Guardian
extends Sigil

@export var once_per_turn:bool

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Guardian.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "When an enemy card is played, this creature moves into the space opposing it (if able)."
	return super.get_desc().format([construct])
