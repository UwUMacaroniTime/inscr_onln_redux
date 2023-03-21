class_name Sigil_SharpQuills
extends Sigil

@export var damage:int = 1

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Sharp Quills.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "When this is struck, deal " + str(damage) + " damage to the attacker."
	return super.get_desc().format([construct])
