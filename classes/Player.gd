class_name Player


class Cardslot:
	var card:Control
	var slot:Button
	var resting_sigils:Array[Sigil]
	var where:Vector2i
	
	func _init(loc:Vector2i):
		where = loc

var lines := [[
	Cardslot.new(Vector2i(0, 0)),
	Cardslot.new(Vector2i(0, 1)),
	Cardslot.new(Vector2i(0, 2)),
	Cardslot.new(Vector2i(0, 3)),
	],[
	Cardslot.new(Vector2i(1,0)),
	Cardslot.new(Vector2i(1,1)),
	Cardslot.new(Vector2i(1,2)),
	Cardslot.new(Vector2i(1,3)),
]]
var hand:Array[Card]
var idx:int
var deck:DeckObject

# hammer + meta stuff
var hammer_smashes:int = Battlemanager.base_hammer_smashes

# costs
var energy:int
var max_energy:int

var bones:int
var heat:int
var notes:int

var bmox:int
var omox:int
var gmox:int
var total_mox:int

func _init(decl_idx:int):
	idx = decl_idx

func setup():
	deck.main_deck.shuffle()
	deck.side_deck.shuffle()
	
	# draw opening hand
	for _i in Battlemanager.base_maindeck_cards_in_opening_hand:
		var card_data :CData = deck.main_deck.pop_front()
		hand.append(card_data)
		Fightscene.vis_add_card_to_hand(card_data, Fightscene.hands[idx], idx == 0)
	for _i in Battlemanager.base_sidedeck_cards_in_opening_hand:
		var card_data :CData = deck.side_deck.pop_front()
		hand.append(card_data)
		Fightscene.vis_add_card_to_hand(card_data, Fightscene.hands[idx], idx == 0)
	
	bones = 0
	heat = 0
	notes = 0
	
