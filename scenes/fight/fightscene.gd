extends Control

enum player {
	client,
	enemy
}

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

func vis_draw_from_deck(deck:DeckButton, hand:Container, card_data:CData):
	var card = preload("res://scenes/card/card.tscn").instantiate()
	card.data = card_data
	
	card.position = deck.get_global_transform().origin - hands[0].get_global_transform().origin
	hands[0].add_child(card)
	
	card.visual_apply()
	card.anim_player.play(&"flipfrom")
	card.text = deck.text
	deck.cur_val -= 1
	deck.vis_apply()

func _on_main_deck_pressed():
	vis_draw_from_deck($"ClientDecks/Main Deck", hands[0], preload("res://data/cards/49er.tres"))

func _on_side_deck_pressed():
	vis_draw_from_deck($"ClientDecks/Side Deck", hands[0], preload("res://data/cards/bullfrog.tres"))
