extends RefCounted
class_name GameEvent

enum piles {
	DECK = 0,
	SIDEDECK = 1,
	GRAVEYARD,
	HAND,
}

enum event_return_flag {
	AND_STOP = 1 << 0, ## ONLY USE THIS FLAG IF ABSOLUTELY NESSICARY. This flag terminates the rest of the event, making no other listeners able to react to it.
	OVERRIDE_DEFAULT = 1 << 1, ## continue the loop, but stop the default behaviour. Only works if the event is a "pre" event with default behaviour.
}

## the most generic event. every game event derives from this.
class BasicEvent extends Node:
	## determines if this an event that happens before the event resolves.
	## only "Pre" events can OVERRIDE_DEFAULT.
	var pre:bool
	var event_return_flags:int
	var input_stall:bool = true
	
	## makes an artifical delay to await for.
	func delay(sec:float):
		var timer = Timer.new()
		timer.start(sec)
		await timer.timeout
	
	## propigates the event through the battlefield.
	func echo():
		Fightscene.inputless = input_stall
		await propigate()
		
		if !(event_return_flags & event_return_flag.OVERRIDE_DEFAULT):
			await echo_default()
		
		Fightscene.inputless = !input_stall
	
	## incomplete propigation. Don't call this.
	func propigate():
		# where for loops go to die
		for player in Battlemanager.get_players_ordered():
			for line in player.lines:
				for slot in line:
					
					if slot.card != null:
						for sigil in slot.card.data.sigils:
							await sigil.event(self)
							
							if event_return_flags & event_return_flag.AND_STOP:
								return
	
	## virtual method for default echo behaviour
	func echo_default():
		pass

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
	func echo_default():
		var card_die = CardDie.new()
		card_die.card = card
		
		await card_die.echo()

class PlayerSacrificeCard extends PlayerCardTargetedAction:
	func echo_default():
		var card_die = CardDie.new()
		card_die.card = card
		
		await card_die.echo()

class PlayerPlayCard extends PlayerCardTargetedAction:
	var position:Vector2i
	
	func echo_default():
		var card_move_from_pile = CardMoveFromPile.new()
		card_move_from_pile.card = card
		card_move_from_pile.from = piles.HAND
		card_move_from_pile.to = position
		await card_move_from_pile.echo()

class PlayerDrawCard extends PlayerCardTargetedAction:
	var from:piles
	
	func echo_default():
		assert(from < piles.GRAVEYARD) # assert: from must be a location before graveyard idx
		var deck_container :DeckButton =  \
		Fightscene.get_node(("Client" if source.idx == 0 else "Enemy") + "Decks") \
		.get_child(from) # if we are trying to get child 2 (graveyard) or child 3 (hand) 
			# as our from, something has gone awfully wrong.
		
		await Fightscene.vis_draw_from_deck(deck_container, Fightscene.hands[source.idx], \
		(source.deck.main_deck if from == piles.DECK else source.deck.side_deck).pop_front() \
		)

class CardEvent extends BasicEvent:
	var card:Card

class CardDie extends CardEvent:
	func echo_default():
		card.anim_player.play("die")
		print("started anim, waiting...")
		await card.anim_player.animation_finished
		print("finished anim, deleting")
		# remove damage and non-permanent buffs from card
		card.data.health_mod = 0
		card.data.attack_mod = 0
		
		# put the card in the  graveyard of the player you're on the side of
		Battlemanager.card.player_owner.bones += 1
		Battlemanager.card.player_owner.graveyard.append(card.data)
		card.queue_free()

class CardMove extends CardEvent:
	var to:Vector2i
	
	func echo_default():
		
		Battlemanager.get_virtual_slot(to).card = card
		card.grid_pos = to
		await Fightscene.vis_play_card(card, to)

class CardMoveFromPile extends CardMove:
	var from:piles
	

class CardMoveFromSlot extends CardMove:
	var from:Vector2i
	
	func echo_default():
		await Fightscene.vis_play_card(card, to)
		Battlemanager.get_virtual_slot(from).card = null
		
		return await super.echo_default()

class BellRing extends PlayerAction:
	
	func echo():
		# we have a prereq to do:
		for player in Battlemanager.get_players_ordered():
			for line in player.lines:
				for slot in line:
					
					if slot.card != null:
						for sigil in slot.card.data.sigils:
							await sigil.event(self)
							
							if event_return_flags & event_return_flag.AND_STOP:
								return
						await Fightscene.vis_card_attack_slot(slot.card, Vector2i(0,0))
	pass


