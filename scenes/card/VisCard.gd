class_name VisCard
extends Control

export var sigils:PoolStringArray = PoolStringArray(["A", "B", "C", "D"])
var sigil_scene = preload("res://scenes/card/sigil/Sigil.tscn")

func _ready():
	redraw_sigils()

func redraw_sigils():
	var sigils_display = $CardBase/Sigils
	
	for child in sigils_display.get_children():
		print(child)
		child.queue_free()
	
	for sigil_name in sigils:
		var sigil_instance:TextureRect = sigil_scene.instance()
		sigils_display.add_child(sigil_instance)
	
	if len(sigils) * 50 > sigils_display.rect_size.x:
		# temporary solution
		sigils_display.columns = 2
	else:
		sigils_display.columns = len(sigils)
		pass
	
	pass
