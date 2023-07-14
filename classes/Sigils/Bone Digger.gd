@icon("res://gfx/sigils/Bone Digger.png")
class_name Sigil_BoneDigger
extends Sigil

@export var amount:int = 1

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Bone Digger.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "At the start of owner's turn, owner gains " + str(amount) + " bones."
	return super.get_desc().format([construct])
