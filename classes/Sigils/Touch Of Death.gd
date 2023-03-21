class_name Sigil_TouchOfDeath
extends Sigil

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Touch of Death.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "When thid deals damage to a card, it perishes."
	return super.get_desc().format([construct])
