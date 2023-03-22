class_name  CData
extends Resource

enum TRIBES {
	Canine, ## The-jack-of-all-trades tribe. Don't really specialize in anything, but have general synergy.
	Feline, 
	Reptile, ## Reptiles have good high value target shutdown- whether by outright removing or by blocking damage.
	Rodent, ## Rodents mostly specialize in both expendability and defense. 
	Fish, ## Fish consist almost entirely of waterborne cards.
	Feathered, ## Feathered are usually airborne and provide utility and direct damage.
	Insect, ## Cheap and squishy but threatening units that can easily pile up if you aren't careful.
	Ant, ## Ants count towards the "Ants" special stat.
	Hooved, ## Hooved cards are especially mobile,characterized by sigils like Sprinter and Hefty
	Bluecollar,
	Military, ## Military are not afraid to detonate everything in firey explosions, including themselves.
	Construct, ## Constructs primarily are very low attack, high health units.
	Scoundrel, ## Outlaws, Bandits, and Outcasts. love having open spaces to deal direct damage into.
	Royal, ## Anything that is revered or at the top a monarchratic system. Royals are usually squishy but have high value, so that Royal Protector cards may synergize well with them.
	Ghost, ## Miscelaneous non-physical spirits. Highly expendable or actively want to die.
	Marrowite, ## Marrowites are mostly skeletons, or skeleton-esq such as Exeskeleton. Often brittle.
	Cadaver, ## Cadavers are mostly zombies or dead bodies. Soak up damage like a sponge.
	Mox, ## Mox count towards the "Gem Guardian", "Mental Gemnastics", and "Gem Dependant" sigils.
	Damned, ## Disgraced by society, usually demon-creatures. 
}

enum SPECIAL_STAT {
	None,
	Ants,
	Mox,
	Hand_Size,
	Mirror_Attack,
	Mirror_Health,
	Bell_Proximity,
}

## The visual artwork of the card.
@export var portait:Texture2D = preload("res://gfx/pixport/49er.png")

## see [enum TRIBES].
@export var tribes:Array[TRIBES]

@export var sigils:Array[Sigil]

## The attack value of the card.
@export var attack:int
## See [enum SPECIAL_STAT].
@export var attack_special:SPECIAL_STAT
## The health value of the card.
@export var health:int = 1
## See [enum SPECIAL_STAT].
@export var health_special:SPECIAL_STAT

@export var conductive:bool = false

# COSTS

@export_group("Costs")

@export_subgroup("Blood")
## The amount of blood sacrifices nessicary to play this.
## If you don't know how to do blood sacrifices, god help you.
@export var blood_cost:int
## The amount of sap sacrifices nessicary to play this. 
## Works like blood, but Terrain cards may be sacrified
@export var sap_cost:int

@export_subgroup("Mox")
## The amount of green mox gems nessicary to play this. 
@export_range(0, 4) var mox_green_cost:int
## The amount of orange mox gems nessicary to play this. 
@export_range(0, 4) var mox_orange_cost:int
## The amount of blue mox gems nessicary to play this. 
@export_range(0, 4) var mox_blue_cost:int
## The amount of unspecified mox gems nessicary to play this. 
##
## A card that costs 1 Prisim can
## subsitute it's cost for any other mox color, but cards that generate prisim mox are not subsitutes
## for mox colors. 
## TLDR: it's Colorless mana from Magic: The Gathering
@export_range(0, 4) var mox_prisim_cost:int

@export_subgroup("Bones")
## The amount of bones consumed when this card is played. 
## 1 Bone is generated when a friendly card dies.
@export var bone_cost:int

@export_subgroup("Energy")
## The amount of energy consumed when this card is played.
##
## Energy is generated like Hearthstone's Mana.
@export_range(0, 6, 1, "or_greater") var energy_cost:int
## The amount of energy cells consumed when this card is played.
##
## Energy Cells are generated like Hearthstone's Mana Crystals.
@export_range(0, 6, 1, "or_greater") var energy_max_cost:int

@export_subgroup("Runes")
## The amount of runes nessicary to play this.
##
## Runes are equal to the amount of sigils on the friendly side of the board.
@export_range(0, 1, 1, "or_greater") var rune_cost:int

@export_subgroup("Heat")
## The amount of heat consumed by playing this card. 
##
## 1 Heat is generated when the player discards a card.
@export var heat_cost:int

@export_group("Metadata")

## Whether or not the card is allowed in your main deck.
@export var banned:bool = false

## If true, only one copy of this card is allowed in your main deck.
@export var rare:bool = false

## Appears in the deck editor. Put any credits and/or flavor text here.
@export_multiline var description:String 
