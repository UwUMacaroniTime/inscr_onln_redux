extends Control

enum player {
	client,
	enemy
}

signal selected_creature(card:Card)
signal selected_card(card:Card)

var cur_selected_card:Card

@onready var hands :Array[Node] = [$ClientHand, $EnemyHand]
@onready var player_uis :Array[Node] = [ $ClientUI, $EnemyUI,]
@onready var lines :Array[Node] = [$Lines/Backline0, $Lines/Frontline0, $Lines/Backline1, $Lines/Frontline1]

func get_slot(side:player, frontline:int, idx:int):
	return lines[side * 2 + int(frontline)].get_child(idx)

func _ready():
	for p in Battlemanager.players:
		p.deck = DeckObject.new()
		p.deck.main_deck = [
			preload("res://data/cards/49er.tres"),
			preload("res://data/cards/49er.tres"),
			preload("res://data/cards/49er.tres"),
			preload("res://data/cards/49er.tres"),
			preload("res://data/cards/49er.tres"),]
		p.deck.side_deck = [preload("res://data/cards/bullfrog.tres")]
	
	Battlemanager.synced_prebattle_setup(0)
	
#	print("hands: ", hands[0].get_children())


func vis_add_card_to_hand(card_data:CData, hand:Container, hide_back:bool):
	var card = preload("res://scenes/card/card.tscn").instantiate()
	card.data = card_data
	
	card.get_node("vertical").visible = hide_back
	
	hand.add_child(card)
	card.pressed_bound.connect(_on_card_pressed)
	card.visual_apply()
	

func vis_draw_from_deck(deck:DeckButton, hand:Container, card_data:CData):
	var card = preload("res://scenes/card/card.tscn").instantiate()
	card.data = card_data
	
	card.position = deck.get_global_transform().origin - hand.get_global_transform().origin
	hand.add_child(card)
	
	card.pressed_bound.connect(_on_card_pressed)
	
	card.visual_apply()
	card.anim_player.play(&"flipfrom")
	card.text = deck.text
	deck.cur_val -= 1
	deck.vis_apply()

func _on_main_deck_pressed():
	vis_draw_from_deck($"ClientDecks/Main Deck", hands[0], preload("res://data/cards/49er.tres"))

func _on_side_deck_pressed():
	vis_draw_from_deck($"ClientDecks/Side Deck", hands[0], preload("res://data/cards/bullfrog.tres"))

func _on_card_pressed(card:Card):
	selected_card.emit(card)
	cur_selected_card = card

func _on_creature_pressed(card:Card):
	selected_creature.emit(card)
	cur_selected_card = null

func _on_slot_pressed(pos:Vector2i):
	if cur_selected_card != null:
		var slot:Control = lines[pos.y].get_child(pos.x)
		
		print("we got a card we can do with!!")
		cur_selected_card.position = cur_selected_card.get_global_transform().origin \
		- slot.get_global_transform().origin
		hands[0].remove_child(cur_selected_card)
		cur_selected_card.pressed_bound.disconnect(_on_card_pressed)
		cur_selected_card.pressed_bound.connect(_on_creature_pressed)
		
		slot.add_child(cur_selected_card)
		var tween = create_tween()
		tween.tween_property(cur_selected_card, "position", Vector2.ZERO, 1.0)
		cur_selected_card = null

