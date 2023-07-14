@icon("res://gfx/sigils/Bifurcated Strike.png")
class_name Sigil_SplitStrike
extends Sigil

@export var attack_left:bool = true
@export var attack_right:bool = true
@export var attack_ahead:bool = false

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Bifurcated Strike.png")
	return icon_override

func get_desc() -> String:
	var construct:String = "While attacking, This creature strikes "
	if attack_left:
		construct += "to the left"
		if attack_right:
			construct += " and "
	
	if attack_right:
		construct += "to the right"
	
	if not attack_ahead:
		construct += " instead of striking forward"
	
	construct += "."
	
	return super.get_desc().format([construct])
