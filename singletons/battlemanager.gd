extends Node

var players:Array[Player] = [Player.new(0), Player.new(1)]
var host:int
var current_player:int = 0

const base_maindeck_cards_in_opening_hand = 4
const base_sidedeck_cards_in_opening_hand = 1
const base_hammer_smashes = 1

signal player_gained_card(card:CData, player:Player)

@rpc("authority", "call_local")


## syncronizes random seed, shuffles decks
func synced_prebattle_setup(random_seed:int):
	seed(random_seed)
	
	# setup the host *first*. 
	# Important, because otherwise would desync
	
	players[host].setup()
	players[1 - host].setup()

func get_virtual_slot(pos:Vector2i) -> Player.Cardslot:
	return get_player(pos).lines[pos.y % 2][pos.x]

func get_player(pos:Vector2i) -> Player:
	return players[pos.y / 2]
