class_name Card
extends Button

@export var data:CData
@export var scale_manip:float = 1.2
@onready var anim_player:AnimationPlayer = %AnimationPlayer
var hovered:bool = false

signal pressed_bound(card:Card)
signal hover_bound(card:Card)

var sigil_scne = preload("res://scenes/card/sigil.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if not SettingsManager.settings.card_IconOverlay_semitransparent:
		$IconOverlay.modulate = Color.WHITE
	if not SettingsManager.settings.card_Name_visible:
		%Name.visible = false
#	visual_apply()

func visual_apply():
	%Name.text = data.resource_name
	%Portrait.texture = data.portait
	
	var tribe_text = %TribeText
	if SettingsManager.settings.card_TribeText_visible:
		tribe_text.visible = bool(len(data.tribes))
		tribe_text.text = " -"
		for tribe in data.tribes:
			tribe_text.text += " " + data.TRIBES.find_key(tribe).to_pascal_case()
		tribe_text.text += " - "
		tribe_text.tooltip_text = tribe_text.text
	else:
		tribe_text.visible = false
	
	var sigils :GridContainer = %Sigils
	var patches :HBoxContainer = %Patches
	
	for sigil in sigils.get_children():
		sigil.queue_free()
	
	for sigil in patches.get_children():
		sigil.queue_free()
	
	var conduit_band :TextureRect = %ConduitBand
	conduit_band.visible = data.conductive
	
	var mox = %Mox
	
	mox.visible = (data.mox_blue_cost > 0 or data.mox_green_cost > 0 or data.mox_orange_cost > 0 or data.mox_prisim_cost > 0)
	
	if mox.visible:
		# not a good idea, frankly
		var path := "res://gfx/cardextras/costs/mox/mox-"
		path = path.rpad(len(path) + data.mox_orange_cost, "o")
		path = path.rpad(len(path) + data.mox_blue_cost, "b")
		path = path.rpad(len(path) + data.mox_green_cost, "g")
		path = path.rpad(len(path) + data.mox_prisim_cost, "p")
		path += ".png"
		print(path)
		mox.texture = load(path)
	
	_vis_ld_cost(%Sap, "blood/sap", data.sap_cost, 
	"You must Sacrifice {0} creature(s) you own to pay this cost.
	Sacrificing a creature will kill it. All creatures can be Sacrificed for Sap.")

	_vis_ld_cost(%Blood, "blood/blood", data.blood_cost,
	"You must Sacrifice {0} creature(s) you own to pay this cost.
	Sacrificing a creature will kill it. Some creatures cannot be Sacrificed for Blood.")
	_vis_ld_cost(%Energy, "energy/energy", data.energy_cost, 
	"you must remove {0} Energy to pay this cost.
	You get +1 maximum Energy (cells) per turn to a maximum of 6.
	All energy regenarates at the start of a turn and unspent Energy is wasted.")
	_vis_ld_cost(%Cells, "energy/cells", data.energy_max_cost, 
	"You must remove {0} maximum Energy (Cells) to pay this cost.
	You get +1 maximum Energy (cells) per turn to a maximum of 6.")
	_vis_ld_cost(%Bones, "bones/bones", data.bone_cost, 
	"You must remove {0} Bone(s) to pay this cost.
	You gain a Bone whenever a creature you own dies.")
	_vis_ld_cost(%Heat, "heat/heat", data.heat_cost, 
	"You must remove {x} Heat to pay this cost.
	You gain one Heat whenever you discard a card.
	You may discard cards in your hand at will by using the hammer on them.")
	
	if not data.sacrificable:
		_vis_add_sigil(patches, preload("res://data/sigils/patches/Unsacrificable.tres"))
	
	# sigil adding
	
	for sigil in data.sigils:
		_vis_add_sigil(sigils, sigil)
	
	if len(data.sigils) >= 2:
		sigils.columns = 2
	else:
		sigils.columns = 1
	
	if not SettingsManager.settings.card_stat_scratches:
		%AtkLabel.text = str(data.attack)
		%HpLabel.text = str(data.health)
	else:
		%AtkLabel.text = "".lpad(data.attack, "I")
		%HpLabel.text = "".lpad(data.health, "I")

func _vis_add_sigil(parent:Container, sigil:Sigil):
	var sigil_instance :TextureRect = sigil_scne.instantiate()
	parent.add_child(sigil_instance)
	sigil_instance.texture = sigil.get_icon()
	sigil_instance.tooltip_text = sigil.get_desc()

func _vis_ld_cost(display:TextureRect, root:String, value:int, desc:String):
	display.visible = value
	
	if not value:
		return
	
	display.tooltip_text = desc.format([value])
	display.texture = load("res://gfx/cardextras/costs/" + root + str(value) + ".png")

func _on_pressed():
	pressed_bound.emit(self)
	

func _on_mouse_entered():
	hover_bound.emit(self)
	if anim_player.is_playing() or hovered:
		return
	scale *= scale_manip
	hovered = true
	z_index += 1
	

func _on_mouse_exited():
	if anim_player.is_playing() or not hovered:
		return
	
	hovered = false
	scale /= scale_manip
	z_index -= 1

func toggle_icon_overlay():
	var icon_overlay = $IconOverlay
	icon_overlay.visible = !icon_overlay.visible

