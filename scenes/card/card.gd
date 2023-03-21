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
	if not SettingsManager.settings.card_TribeText_visible:
		%TribeText.visible = false
#	visual_apply()

func visual_apply():
	%Name.text = data.resource_name
	%Portrait.texture = data.portait
	
	var tribe_text = %TribeText
	tribe_text.visible = bool(len(data.tribes))
	tribe_text.text = " -"
	for tribe in data.tribes:
		tribe_text.text += " " + data.TRIBES.find_key(tribe).to_pascal_case()
	tribe_text.text += " - "
	
	var sigils :GridContainer = %Sigils
	
	for sigil in sigils.get_children():
		sigil.queue_free()
	
	for sigil in data.sigils:
		var sigil_instance :TextureRect = sigil_scne.instantiate()
		sigils.add_child(sigil_instance)
		sigil_instance.texture = sigil.get_icon()
	
	if len(data.sigils) >= 2:
		sigils.columns = 2
	else:
		sigils.columns = 1
	
	%AtkLabel.text = str(data.attack)
	%HpLabel.text = str(data.health)

func _on_pressed():
	pressed_bound.emit(self, loc)


func _on_mouse_entered():
	hover_bound.emit(self, loc)
	scale *= scale_manip
	z_index += 1

func _on_mouse_exited():
	scale /= scale_manip
	z_index -= 1

