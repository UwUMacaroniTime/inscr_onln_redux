extends Control

@onready var mode_select := %ModeSelect
@onready var main_deck := %"Main Deck"
@onready var main_deck_list := %MaindeckList
@onready var side_deck := %"Side Deck"
@onready var side_deck_list := %SidedeckList
@onready var preview_card :Card = %PreviewCard
@onready var card_browser_list = %Allcards
@onready var scrybe_browser_list = %ScrybeBrowser
@onready var preview_scrybe = %PreviewScrybe

var card_scn:PackedScene = load("res://scenes/card/card.tscn")
var card_decks:Array[Dictionary] = [{}, {}]
var scrybes = []
var scrybe_data :ScrybeData
var min_main_size = 20
var min_side_size = 5

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
	scrybe_browser_list.clear()
	for file in DirAccess.get_files_at("res://data/scrybes"):
		var scrybe :ScrybeData = load("data/scrybes/" + file)
		scrybes.append(scrybe)
		scrybe_browser_list.add_item(scrybe.resource_name, scrybe.portrait)

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

func _scrybe_selected(idx:int):
	var scrybe_desc := %ScrybeDesc
	var portrait := $Split/PreviewScrybe/Portrait
	var backdrop :TextureRect = $Split/PreviewScrybe/Title/Name/Gradient
	var title := $Split/PreviewScrybe/Title/Title
	var name := $Split/PreviewScrybe/Title/Name
	scrybe_data = scrybes[idx]
	scrybe_desc.text = scrybe_data.description
	portrait.texture = scrybe_data.portrait
	backdrop.texture = scrybe_data.name_tex
	backdrop.material = scrybe_data.name_mat
	title.text = scrybe_data.title
	name.text = scrybe_data.resource_name
#	portrait.material.set_shader_parameter("palette", scrybe_data.name_tex)

func _on_mode_select_tab_changed(tab:int):
	main_deck.visible = false
	side_deck.visible = false
	var card_browser := %CardBrowser
	card_browser.visible = false
	scrybe_browser_list.visible = false
	preview_scrybe.visible = false
	
	match tab:
		0:
			main_deck.visible = true
			card_browser.visible = true
		1:
			side_deck.visible = true
			card_browser.visible = true
		2:
			scrybe_browser_list.visible = true
			preview_scrybe.visible = true

func deck_size(loc:card_location) -> int:
	var total = 0
	for card in card_decks[loc]:
		total += card_decks[loc][card]
	return total

func _card_selected(card:Card, loc:int):
	match loc:
		card_location.BROWSER:
			match mode_select.current_tab:
				0:
					if card_decks[0].get(card.data.resource_name, 1) >= 4:
						return
					
					var new_card : = gen_card(card_location.MAINDECK)
					new_card.data = card.data
					new_card.visual_apply()
					
					card_decks[0][card.data.resource_name] = card_decks[0].get(card.data.resource_name, 0) + 1
				1:
					if card_decks[1].get(card.data.resource_name, 1) >= 10:
						return
					
					var new_card : = gen_card(card_location.SIDEDECK)
					new_card.data = card.data
					new_card.visual_apply()
					
					card_decks[1][card.data.resource_name] = card_decks[1].get(card.data.resource_name, 0) + 1
		card_location.SIDEDECK:
			card.queue_free()
			card_decks[1][card.data.resource_name] -= 1
		card_location.MAINDECK:
			card.queue_free()
			card_decks[0][card.data.resource_name] -= 1
	udate_deck_size_info()

func _card_hovered(card:Card, _loc:int):
	preview_card.data = card.data
	preview_card.visual_apply()

func udate_deck_size_info():
	var size_info := $ButtonsNStuff/SizeInfo
	size_info.text = ""
	var main_size := deck_size(card_location.MAINDECK)
	var side_size := deck_size(card_location.SIDEDECK)
	if main_size < min_main_size:
		size_info.text += "[color=red]"
	size_info.text += "main deck: " + str(main_size) + "/" + str(min_main_size) + "\n"
	
	if main_size < min_main_size and not side_size < min_side_size:
		size_info.text += "[/color]"
	
	size_info.text += "side deck: " + str(side_size) + "/" + str(min_side_size)

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
