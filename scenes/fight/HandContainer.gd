@tool
extends Container

@export var sort_left:bool

func sortening():
	var fill:float
	
	# calc the fill with no offsets
	for c in get_children():
		fill += c.size.x # don't count the scale
	
	# isolate and solve for the offset needed to fill the space
	var ofst = min((size.x - fill) / get_child_count(), 0) # if we need to space cards out instead of bunch, ignore
	
	
	if sort_left:
		fill = 0
	else:
		fill = size.x + ofst
	
	for i in get_child_count():
		var c := get_child(i)
		if sort_left:
			fill += ofst + c.size.x if i > 0 else 0
		
		else:
			fill -= c.size.x + ofst
		c.position.x = fill


func _on_sort_children():
	sortening()
