class_name SettingsRes
extends Resource

@export var card_IconOverlay_semitransparent:bool = true
@export var card_TribeText_visible:bool = true
## dislexia stuff
@export var card_Name_visible:bool = true
@export var card_stat_scratches:bool = false

@export var network_enable:bool = false
@export var disable_network_warning:bool = false

@export_global_file("*.res") var default_deck:String
@export var default_deckbuilder_split_offset:int
