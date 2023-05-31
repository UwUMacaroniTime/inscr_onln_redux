class_name Sigil
extends Resource

@export var icon_override:Texture2D

enum use_param {
	UNRESTRICTED,
	ONCE_PER_TURN,
	ONCE_ONLY,
}

## how many runes this sigil is worth.
@export var rune_value:int = 1

@export_group("Misc")
@export var use_restrictions:use_param = use_param.UNRESTRICTED

func get_icon() -> Texture2D:
	# default sigil art
	if icon_override == null:
		return preload("res://gfx/sigils/Airborne.png")
	return icon_override

func get_desc() -> String:
	var construct:String = ""
	match use_restrictions:
		use_param.ONCE_PER_TURN:
			construct += "Once per turn: {0}"
		use_param.ONCE_ONLY:
			construct += "{0} Once this sigil triggers, remove this sigil."
		_:
			construct += "{0}"
	if rune_value != 1:
		construct += " This sigil is worth " + str(rune_value) + " Runes."
	return construct


func resolved() -> void:
	# we gotta delete if we have ONCE_ONLY
	pass

func _player_drew_card():
	await resolved
