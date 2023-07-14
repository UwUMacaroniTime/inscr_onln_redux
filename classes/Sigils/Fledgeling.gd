@icon("res://gfx/sigils/Fledgling.png")
class_name Sigil_Fledgeling
extends Sigil

@export var evolution_form:CData
## The turns until a card bearing this sigil evolves.
@export_range(1, 2, 1, "or_greater") var turns_to_evolve:int = 1

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Fledgling.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "This will turn into a " + evolution_form.resource_name + " after " + str(turns_to_evolve) + " turn(s) on the board."
	
	return super.get_desc().format([construct])
