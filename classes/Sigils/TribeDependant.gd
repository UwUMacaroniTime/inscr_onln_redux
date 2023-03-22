class_name Sigil_TribeDependant
extends Sigil

@export var tribe:CData.TRIBES = CData.TRIBES.Mox

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Gem Dependant.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "If owner controls no \"" \
	+ CData.TRIBES.find_key(tribe)\
	+ "\" creatures, this perishes."
	return super.get_desc().format([construct])
