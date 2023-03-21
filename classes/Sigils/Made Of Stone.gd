class_name Sigil_MadeOfStone
extends Sigil

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Made of Stone.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "This is immune to the effects of Stinky and Touch Of Death."
	return super.get_desc().format([construct])
