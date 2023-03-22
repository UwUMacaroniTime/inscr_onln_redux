extends Control

@onready var mode_select := %ModeSelect
@onready var main_deck := %"Main Deck"
@onready var main_deck_list := %MaindeckList
@onready var side_deck := %"Side Deck"
@onready var side_deck_list := %SidedeckList
@onready var preview_card :Card = %PreviewCard
@onready var card_browser_list = %Allcards

var card_scn:PackedScene = load("res://scenes/card/card.tscn")
var cards:Array[Dictionary] = [{}, {}]

enum card_location {
	MAINDECK,
	SIDEDECK,
	BROWSER,
}

func _ready():
	randomize()
	
	for file in DirAccess.get_files_at("res://data/cards"):
		var card := gen_card(card_location.BROWSER)
		# just assume it's a CData file. If it isn't this all messes up anyway
		card.data = load("data/cards/" + file)
		card.visual_apply()

func gen_card(loc:card_location) -> Card:
	var card_instance :Card = card_scn.instantiate()
	card_instance.hover_bound.connect(self._card_hovered)
	card_instance.pressed_bound.connect(self._card_selected)
	card_instance.loc = loc
	match loc:
		card_location.MAINDECK:
			main_deck_list.add_child(card_instance)
		card_location.SIDEDECK:
			side_deck_list.add_child(card_instance)
		card_location.BROWSER:
			card_browser_list.add_child(card_instance)
	return card_instance

func _on_mode_select_tab_changed(tab:int):
	main_deck.visible = false
	side_deck.visible = false
	var card_browser := %CardBrowser
	card_browser.visible = false
	
	match tab:
		0:
			main_deck.visible = true
			card_browser.visible = true
		1:
			side_deck.visible = true
			card_browser.visible = true

func deck_size(loc:card_location) -> int:
	var total = 0
	for card in cards[loc]:
		total += cards[loc][card]
	return total

func _card_selected(card:Card, loc:int):
	match loc:
		card_location.BROWSER:
			match mode_select.current_tab:
				0:
					if cards[0].get(card.data.resource_name, 1) >= 4:
						return
					
					var new_card : = gen_card(card_location.MAINDECK)
					new_card.data = card.data
					new_card.visual_apply()
					
					cards[0][card.data.resource_name] = cards[0].get(card.data.resource_name, 0) + 1
				1:
					if cards[1].get(card.data.resource_name, 1) >= 10:
						return
					
					var new_card : = gen_card(card_location.SIDEDECK)
					new_card.data = card.data
					new_card.visual_apply()
					
					cards[1][card.data.resource_name] = cards[1].get(card.data.resource_name, 0) + 1
		card_location.SIDEDECK:
			card.queue_free()
			cards[1][card.data.resource_name] -= 1
		card_location.MAINDECK:
			card.queue_free()
			cards[0][card.data.resource_name] -= 1

func _card_hovered(card:Card, _loc:int):
	preview_card.data = card.data
	preview_card.visual_apply()

func _on_search_pressed():
	var name_edit :LineEdit = $ButtonsNStuff/NameEdit
	var cost :OptionButton = $ButtonsNStuff/Cost
	for card in card_browser_list.get_children():
#			print(card.data.resource_name, ": ", card.data.resource_name.similarity(name_edit.text))
		if not name_edit.text.is_empty() and card.data.resource_name.similarity(name_edit.text) < 0.02:
			card.visible = false
			continue
		
		if cost.selected == 1 and (card.data.blood_cost == 0 \
		and card.data.sap_cost == 0):
			card.visible = false
			continue
		
		if cost.selected == 2 and card.data.bone_cost == 0:
			card.visible = false
			continue
		
		if cost.selected == 3 and card.data.energy_cost == 0:
			card.visible = false
			continue
		
		if cost.selected == 4 and (card.data.mox_green_cost == 0 \
		and card.data.mox_blue_cost == 0 \
		and card.data.mox_orange_cost == 0 \
		and card.data.mox_prisim_cost == 0):
			card.visible = false
			continue
		
		if cost.selected == 5 and card.data.heat_cost == 0:
			card.visible = false
			continue
		
		card.visible = true
