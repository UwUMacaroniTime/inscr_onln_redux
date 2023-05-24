class_name DeckButton
extends Button

@export var start_val:int = 20
@onready var cur_val:int = start_val

func vis_apply():
	text = name + "\n(" + str(cur_val) + "/" + str(start_val) + ")"
