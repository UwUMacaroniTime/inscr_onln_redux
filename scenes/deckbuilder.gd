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
var deck_save_path :String
var min_main_size = 30
var min_side_size = 5

enum card_location {
	MAINDECK,
	SIDEDECK,
	BROWSER,
}

const default_deck_maximum := [4, 10]

func _ready():
#	randomize()
	
	var tribe :OptionButton = $ButtonsNStuff/Tribe
	
	for item in CData.TRIBES:
		tribe.add_item(item, CData.TRIBES[item] + 1)
	
	for file in DirAccess.get_files_at("res://data/cards"):
		var card := gen_card(card_location.BROWSER)
		# just assume it's a CData file. If it isn't this all messes up anyway
		file = file.replace(".redirect", "")
		card.data = load("data/cards/" + file)
		card.visual_apply()
	scrybe_browser_list.clear()
	for file in DirAccess.get_files_at("res://data/scrybes"):
		var scrybe :ScrybeData = load("data/scrybes/" + file)
		scrybes.append(scrybe)
		scrybe_browser_list.add_item(scrybe.resource_name, scrybe.portrait)
	
	if FileAccess.file_exists(SettingsManager.settings.default_deck):
		from_data(load(SettingsManager.settings.default_deck))
	
#	$Split.split_offset = SettingsManager.settings.default_deckbuilder_split_offset

func from_data(data:DeckObject):
	for card in main_deck_list.get_children():
		card.queue_free()
	for card in side_deck_list.get_children():
		card.queue_free()
	
	card_decks[0].clear()
	card_decks[1].clear()
	
	if data == null:
		print("Failed to load deck!")
		SettingsManager.settings.default_deck = "" # for safety reasons, remove the deck from the default slot.
		return
	
	for card_data in data.main_deck:
		var card = gen_card(card_location.MAINDECK)
		card.data = card_data
		card.visual_apply()
		card_decks[0][card_data.resource_name] = card_decks[0].get(card_data.resource_name, 0) + 1
	
	for card_data in data.side_deck:
		var card = gen_card(card_location.SIDEDECK)
		card.data = card_data
		card.visual_apply()
		card_decks[1][card_data.resource_name] = card_decks[1].get(card_data.resource_name, 0) + 1
	
	var scridx = scrybes.find(data.scrybe) # sort of icky
	scrybe_browser_list.select(scridx)
	_scrybe_selected(scridx)
	scrybe_data = data.scrybe
	deck_save_path = data.resource_path
	udate_deck_size_info()
	SettingsManager.settings.default_deck = deck_save_path

func to_data():
	var data := DeckObject.new()
	
	for card in main_deck_list.get_children():
		assert(card is Card)
		data.main_deck.append(card.data)
	
	for card in side_deck_list.get_children():
		assert(card is Card)
		data.side_deck.append(card.data)
	
	data.scrybe = scrybe_data
	data.resource_path = deck_save_path
	ResourceSaver.save(data, deck_save_path)

func gen_card(loc:card_location) -> Card:
	var card_instance :Card = card_scn.instantiate()
	
	card_instance.hover_bound.connect(self._card_hovered)
	if loc == card_location.BROWSER:
		card_instance.pressed_bound.connect(self._on_browser_card_selected)
	else:
		card_instance.pressed_bound.connect(self._on_deck_card_selected)
	
	# could use some betterment
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
			hide_deckers(true)
		1:
			side_deck.visible = true
			card_browser.visible = true
			hide_deckers(false)
		2:
			scrybe_browser_list.visible = true
			preview_scrybe.visible = true

func deck_size(loc:card_location) -> int:
	var total = 0
	for card in card_decks[loc]:
		total += card_decks[loc][card]
	return total

func _on_browser_card_selected(card:Card):
	if card_decks[mode_select.current_tab].get(card.data.resource_name, 1) >= default_deck_maximum[mode_select.current_tab]:
		card.anim_player.play(&"no")
		$GlitchSFX.play()
		return
	var new_card : = gen_card(card_location.MAINDECK)
	new_card.data = card.data
	new_card.visual_apply()
	
	card_decks[0][card.data.resource_name] = card_decks[0].get(card.data.resource_name, 0) + 1
	udate_deck_size_info()

func _on_deck_card_selected(card:Card):
	card.queue_free()
	card_decks[1][card.data.resource_name] -= 1
	udate_deck_size_info()

func _card_hovered(card:Card):
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
	var cost_id :int = $ButtonsNStuff/Cost.get_selected_id()
	var tribe_id :int = $ButtonsNStuff/Tribe.get_selected_id() - 1
	for card in card_browser_list.get_children():
#			print(card.data.resource_name, ": ", card.data.resource_name.similarity(name_edit.text))
		card.visible = false
		
		if not name_edit.text.is_empty() and card.data.resource_name.similarity(name_edit.text) < 0.02:
			continue
		
		if cost_id == 1 and (card.data.blood_cost == 0 \
		and card.data.sap_cost == 0):
			continue
		
		if cost_id == 2 and card.data.bone_cost == 0:
			continue
		
		if cost_id == 3 and card.data.energy_cost == 0 \
		and card.data.energy_max_cost == 0:
			continue
		
		if cost_id == 4 and (card.data.mox_green_cost == 0 \
		and card.data.mox_blue_cost == 0 \
		and card.data.mox_orange_cost == 0 \
		and card.data.mox_prisim_cost == 0):
			continue
		
		if cost_id == 5 and card.data.heat_cost == 0:
			continue
		
		if tribe_id != -1 and not tribe_id in card.data.tribes:
			continue
		
		card.visible = true

func hide_deckers(allow_mains:bool):
	# this is seperated from the search function for performance reasons.
	for card in card_browser_list.get_children():
		card.visible = card.data.sidedecker or allow_mains

func _on_file_dialog_file_selected(path):
	if $ButtonsNStuff/FileDialog.file_mode == FileDialog.FILE_MODE_SAVE_FILE:
		deck_save_path = path
		to_data()
	else:
		from_data(load(path))


func _on_eval_pressed():
	var dlg :Array[Dialogue]
	var score:int = 7 
	# despite P03's rating being out of 10, the maximum value you can get is 7.
	var main_deck_size := deck_size(card_location.MAINDECK)
	
	if main_deck_size < min_main_size:
		score -= 2
		dlg.append(load("res://data/dialogue/p03_deck_eval/deck_too_small_en.tres"))
	elif main_deck_size >= min_main_size + 5:
		dlg.append(load("res://data/dialogue/p03_deck_eval/deck_too_big_en.tres"))
	
	var sum := float(len(card_decks[0]))
	var average:float = 0.0
	for card in card_decks[0]:
		average += card_decks[0][card]
	
	average = average / sum
	
	if average < 2.2:
		# if you are running less than 2 copies of a card on average:
		dlg.append(load("res://data/dialogue/p03_deck_eval/deck_too_inconsistent_en.tres"))
	
	score -= abs((main_deck_size - min_main_size) / 2)
	# subtract 1 point for every 2 cards over the minimum.
	# P03 will only mention it if it's substantially bigger.
	
	score -= 3 - int(average)
	
	if score > 5:
		dlg.append(load("res://data/dialogue/p03_deck_eval/deck_fine_en.tres"))
	
	var finalscore :Dialogue = load("res://data/dialogue/p03_deck_eval/deck_finalscore_en.tres")
	finalscore.text = finalscore.text.format([score])
	dlg.append(finalscore)
	
	DialogueWindow.say(dlg)
