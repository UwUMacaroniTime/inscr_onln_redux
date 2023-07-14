class_name Sigil_Aquanaut
extends Sigil

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Aquanaut2.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "This creature strikes submerged cards directly."
	return super.get_desc().format([construct])
