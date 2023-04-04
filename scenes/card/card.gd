class_name Card
extends Button

@export var data:CData
var loc:int = 0
@export var scale_manip:float = 1.2

signal pressed_bound(card:Card, loc:int)
signal hover_bound(card:Card, loc:int)

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
	
	_vis_ld_cost(%Sap, "blood/sap", data.sap_cost)
	_vis_ld_cost(%Blood, "blood/blood", data.blood_cost)
	_vis_ld_cost(%Energy, "energy/energy", data.energy_cost)
	_vis_ld_cost(%Cells, "energy/cells", data.energy_max_cost)
	_vis_ld_cost(%Bones, "bones/bones", data.bone_cost)
	_vis_ld_cost(%Heat, "heat/heat", data.heat_cost)
	
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

func _vis_ld_cost(display:TextureRect, root:String, value:int):
	display.visible = value
	
	if not value:
		return
	
	display.texture = load("res://gfx/cardextras/costs/" + root + str(value) + ".png")

func _on_pressed():
	pressed_bound.emit(self, loc)


func _on_mouse_entered():
	hover_bound.emit(self, loc)
	scale *= scale_manip
	z_index += 1

func _on_mouse_exited():
	scale /= scale_manip
	z_index -= 1

