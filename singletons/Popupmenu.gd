extends Node

@onready var card_popupmenu :PopupMenu= $card_popupmenu
var card :CData

func _on_card_popupmenu_id_pressed(id:int):
	var cardview :Window = $cardview
	match id:
		0:
			cardview.popup_centered(cardview.size)
	pass # Replace with function body.
