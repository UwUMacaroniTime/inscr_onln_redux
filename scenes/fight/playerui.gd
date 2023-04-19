extends Control

@export var lanes:int = 4

func _ready():
	setup()

func setup():
	var slotscn:PackedScene = preload("res://scenes/fight/cardslot.tscn")
	var backline:HBoxContainer = $Lines/Backline
	var frontline:HBoxContainer = $Lines/Frontline
	
	for i in lanes:
		backline.add_child(slotscn.instantiate())
		frontline.add_child(slotscn.instantiate())
