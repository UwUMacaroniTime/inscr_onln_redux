class_name Sigil_Unkillable
extends Sigil

@export var one_time_use:bool = false

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Unkillable.png"
		)
	return icon_override

func get_desc() -> String:
	var construct:String = "When this perishes, return this card to it's owner's hand."
	return super.get_desc().format([construct])
