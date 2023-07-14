@icon("res://gfx/sigils/Bees Within.png")
class_name Sigil_DrawOnHit
extends Sigil

@export var card:CData

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Bees Within.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "When this takes damage, the owner draws a(n) " + card.resource_name + "."
	return super.get_desc().format([construct])
