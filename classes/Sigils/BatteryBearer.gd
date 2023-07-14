@icon("res://gfx/sigils/Battery Bearer.png")
class_name Sigil_BatteryBearer
extends Sigil

@export var cells_gain:int = 1
@export var filled:bool = true

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Battery Bearer.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "When this card is played, owner gains %s " % cells_gain
	if not filled:
		construct += "empty "
	construct += "energy cell(s)."
	return super.get_desc().format([construct])
