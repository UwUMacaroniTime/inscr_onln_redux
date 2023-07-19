@icon("res://gfx/sigils/Ant Spawner.png")
class_name Sigil_DrawOnPlay
extends Sigil

@export var card:CData

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Ant Spawner.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "When this card is played, the owner draws a(n) " + card.resource_name + "."
	return super.get_desc().format([construct])
