class_name Sigil_Detonator
extends Sigil

@export var damage:int = 5

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Detonator.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "When this perishes, deal " + str(damage) + " damage to the opposing card and adjacent friendly cards."
	return super.get_desc().format([construct])
