extends Control

@export var lanes:int = 4
@export var swap_line_order:bool = false

@onready var lines:Array[Node] = [$HBoxContainer/Lines/Backline, $HBoxContainer/Lines/Frontline]
@onready var energy_counter = $HBoxContainer/Status/Energy

@export var energy:int = 6
@export var cells:int = 3


func _ready():
	setup()
	count_energy()

func setup():
	var slotscn:PackedScene = preload("res://scenes/fight/cardslot.tscn")
	
	
	for i in lanes:
		lines[0].add_child(slotscn.instantiate())
		lines[1].add_child(slotscn.instantiate())
	
	if swap_line_order:
		$HBoxContainer/Lines.move_child(lines[0], 1)

func count_energy():
	var eg_childrn:Array[Node] = energy_counter.get_children()
	for idx in len(eg_childrn):
		if eg_childrn[idx] is TextureRect:
			eg_childrn[idx].visible = idx <= energy or idx <= cells
			if idx <= energy:
				eg_childrn[idx].texture = preload("res://gfx/cardextras/costs/energy/energy_icon.png")
			elif idx <= cells:
				eg_childrn[idx].texture = preload("res://gfx/cardextras/costs/energy/cells_icon.png")
			
		else:
			eg_childrn[idx].text = "+" + str(energy - cells)
			eg_childrn[idx].visible = energy > cells
