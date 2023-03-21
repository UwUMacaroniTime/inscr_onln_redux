class_name Sigil_CorpseEater
extends Sigil

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Corpse Eater.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "When a friendly card perishes and this is in your hand, this card gets placed there."
	construct += super.get_desc()
	return construct
