class_name Sigil_Stamp
extends Sigil

@export var gives_tribe:bool = false
@export var tribe:CData.TRIBES

@export var gives_stat:bool = false
@export var attack:int = 0
@export var attack_special:CData.SPECIAL_STAT
@export var health:int = 0
@export var health_special:CData.SPECIAL_STAT

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Backup.png")
	return icon_override

func get_desc() -> String:
	var construct:String = ""
	
	if gives_stat:
		construct += "This counts as a(n) " + CData.TRIBES.find_key(tribe) + "." 
	
	if gives_stat:
		construct += "This has +" + str(attack) + "/" + str(health)
		if health_special:
			if attack_special:
				construct += ", " + CData.SPECIAL_STAT.find_key(attack_special) + " Attack, "
			else:
				construct += " and "
			construct += CData.SPECIAL_STAT.find_key(health_special) + " Health"
		construct += "."
	
	return super.get_desc().format([construct])
