extends Control

@export var lanes:int = 4

@onready var energy_counter = $Energy


func set_player(portrait:Texture2D, name:String):
	$HBoxContainer/Status/Portrait.texture = portrait
	$HBoxContainer/Status/Name.text = name

func count_energy(energy:int, cells:int):
	var eg_childrn:Array[Node] = energy_counter.get_children()
	for idx in len(eg_childrn):
		if eg_childrn[idx] is TextureRect:
			eg_childrn[idx].visible = idx <= cells - 1
			
			if idx <= energy - 1:
				eg_childrn[idx].texture = preload("res://gfx/cardextras/costs/energy/energy_icon.png")
				continue
			else:
				eg_childrn[idx].texture = preload("res://gfx/cardextras/costs/energy/cells_icon.png")
			
		else:
			eg_childrn[idx].text = "+" + str(energy - cells)
			eg_childrn[idx].visible = energy > cells

