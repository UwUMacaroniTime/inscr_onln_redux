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
			preload("res://data/cards/ant.tres"),
			preload("res://data/cards/49er.tres"),
			preload("res://data/cards/49er.tres"),
			preload("res://data/cards/49er.tres"),]
		p.deck.side_deck = [preload("res://data/cards/bullfrog.tres")]
	
	Battlemanager.synced_prebattle_setup(0)
	
#	print("hands: ", hands[0].get_children())
