@icon("res://gfx/sigils/Bone King.png")
class_name Sigil_BoneKing
extends Sigil

@export var amount:int = 4

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Bone King.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "When this perishes, owner gains " + str(amount) + " bones instead of one."
	return super.get_desc().format([construct])
