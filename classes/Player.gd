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

func add_card_to_hand(card_data:CData):
	var card_inst:Card = preload("res://scenes/card/card.tscn").instantiate()
	card_inst.data = card_data
	Fightscene.hands[idx].add_child(card_inst)
	card_inst.visual_apply()
	
	if idx != 0: # if this is not the client:
		card_inst.get_node("vertical").visible = false # messy. make method in card class later.
	
	Battlemanager.player_gained_card.emit(self, card_inst)

func setup():
	deck.main_deck.shuffle()
	deck.side_deck.shuffle()
	
	# draw opening hand
	for _i in Battlemanager.base_maindeck_cards_in_opening_hand:
		add_card_to_hand(deck.main_deck.pop_front())
	for _i in Battlemanager.base_sidedeck_cards_in_opening_hand:
		add_card_to_hand(deck.side_deck.pop_front())
	
	bones = 0
	heat = 0
	notes = 0
	
