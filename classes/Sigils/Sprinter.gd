@icon("res://gfx/sigils/Sprinter.png")
class_name Sigil_Sprinter
extends Sigil

enum MOVEMENT_QUIRK
{
	NONE,
	SHOVE_CARDS,
	SWAP_CARDS,
}

@export var movement_quirk:MOVEMENT_QUIRK

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Sprinter.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "At the end of owner's turn, this moves in the direction inscribed on the sigil"
	
	match movement_quirk:
		MOVEMENT_QUIRK.SHOVE_CARDS:
			construct += ", shoving any cards in its path."
		MOVEMENT_QUIRK.SWAP_CARDS:
			construct += ", chucking cards in its path behind it."
	
	return super.get_desc().format([construct])
