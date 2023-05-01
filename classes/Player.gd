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
var scrybe:ScrybeData

