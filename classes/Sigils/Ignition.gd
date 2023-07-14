class_name Sigil_Ignition
extends Sigil

@export var heat_gain:int = 1

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Relight.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "When this card is played, owner gains %s heat." % heat_gain
	
	return super.get_desc().format([construct])
