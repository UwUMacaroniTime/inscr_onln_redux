@icon("res://gfx/cardextras/unsac_patch.png")
class_name Patch
extends Sigil

@export_multiline var description:String

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/cardextras/unsac_patch.png")
	return icon_override

func get_desc() -> String:
	return description
