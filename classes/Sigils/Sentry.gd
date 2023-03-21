class_name Sigil_Sentry
extends Sigil

enum RANGE {
	OPPOSING_CARD,
	OPPOSING_ADJACENTS,
	ENEMY_CARD,
}

const range_desc := {
	RANGE.OPPOSING_CARD:"When an enemy card moves into the opposing space,",
	RANGE.OPPOSING_ADJACENTS:"When an enemy card moves into the opposing space or adjacent opposing spaces,",
	RANGE.ENEMY_CARD:"When an enemy card moves,"
}

## Damage dealt to opposing card on trigger
@export var damage:int = 1
## The range in which this sigil triggers. See [enum RANGE].
@export var range:RANGE = RANGE.OPPOSING_CARD

## If true, will trigger when this moves too.
@export var trigger_on_this_move:bool = true

func get_icon() -> Texture2D:
	if icon_override == null:
		return preload("res://gfx/sigils/Sentry.png")
	return icon_override

func get_desc() -> String:
	var construct:String = range_desc[range]
	
	construct += " Deal " + str(damage) + " damage to it."
	if trigger_on_this_move:
		construct += " Also, if this is moved, deal " + str(damage) + " damage to the opposing card (if any)."
	
	return super.get_desc().format([construct])
