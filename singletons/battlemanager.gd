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
	for player in get_players_ordered():
		player.setup()

func get_virtual_slot(pos:Vector2i) -> Player.Cardslot:
	var line_y = pos.y % 2
	print(pos, " = player ", pos.y / 2, ": (", line_y , ", ", pos.x,")")
	return get_player(pos).lines[line_y][pos.x]

func get_player(pos:Vector2i) -> Player:
	return players[pos.y / 2]

## get players in deterministic order.
func get_players_ordered() -> Array[Player]:
	return [players[host], players[1 - host]]
