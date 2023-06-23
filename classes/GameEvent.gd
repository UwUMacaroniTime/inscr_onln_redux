extends RefCounted
class_name GameEvent

enum event_return_flag {
	AND_STOP = 1 << 0, ## ONLY USE THIS FLAG IF ABSOLUTELY NESSICARY. This flag terminates the rest of the event, making no other listeners able to react to it.
	OVERRIDE_DEFAULT = 1 << 1, ## continue the loop, but stop the default behaviour. Only works if the event is a "pre" event with default behaviour.
}

## the most generic event. every game event derives from this.
class BasicEvent:
	## determines if this an event that happens before the event resolves.
	## only "Pre" events can OVERRIDE_DEFAULT.
	var pre:bool
	var event_return_flags:int
	
	## makes an artifical delay to await for.
	func delay(sec:float):
		var timer = Timer.new()
		timer.start(sec)
		await timer.timeout
	
	## propigates the event through the battlefield.
	func echo(default:Callable):
		propigate()
		
		if !(event_return_flags & event_return_flag.OVERRIDE_DEFAULT):
			default.call()
		
	
	## incomplete propigation. Don't call this.
	func propigate():
		# where for loops go to die
		for player in Battlemanager.players:
			for line in player.lines:
				for slot in line:
					
					if slot.card != null:
						for sigil in slot.card.sigils:
							await sigil.event(self)
							
							if event_return_flags & event_return_flag.AND_STOP:
								return

## an action performed by a player.
class PlayerAction extends BasicEvent:
	var source:Player

## an action performed by a player that targets a card.
class PlayerCardTargetedAction extends PlayerAction:
	var card:Card

## attempting to discard a card from a hand.
class PlayerBurnCard extends PlayerCardTargetedAction:
	pass

## attempting to hammer a card on the field
class PlayerHammerCard extends PlayerCardTargetedAction:
	pass

class PlayerSacrificeCard extends PlayerCardTargetedAction:
	pass
