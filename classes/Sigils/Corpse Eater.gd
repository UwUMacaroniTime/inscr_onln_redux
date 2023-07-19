@icon("res://gfx/sigils/Corpse Eater.png")
class_name Sigil_CorpseEater
extends Sigil

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Corpse Eater.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "When one of your creatures perish, This card moves into the spot it persihed (if able)."
	construct += super.get_desc()
	return construct
