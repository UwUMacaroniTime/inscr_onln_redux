@tool
extends Container

@export var sort_left:bool
signal reorg_complete

func sortening():
	var fill:float = 0
	
	# calc the fill with no offsets
	for c in get_children():
		fill += c.size.x # don't count the scale
	
	# isolate and solve for the offset needed to fill the space
	var ofst = min((size.x - fill) / get_child_count(), 0) # if we need to space cards out instead of bunch, ignore
	
	
	if sort_left:
		fill = 0
	else:
		fill = size.x + ofst
	var tween := create_tween()
	tween.set_parallel()
	
	for i in get_child_count():
		var c := get_child(i)
		if sort_left:
			fill += ofst + c.size.x if i > 0 else 0
		
		else:
			fill -= c.size.x + ofst
		
		tween.tween_property(c, "position", Vector2(fill, 0), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		#c.position.x = fill
	await tween.finished
	reorg_complete.emit()


func _on_sort_children():
	sortening()


func _input(event):
	if event is InputEventKey and event.key_label == KEY_0 and not event.is_echo() and event.is_pressed():
		for c in get_children():
			move_child(c, randi_range(0, get_child_count() - 1))
		sortening()
