@tool
extends Container

func _on_sort_children():
	var row_fill:int = 0
	var column_fill:int = 0
	var max_height_in_row:int = 0
	
	for c in get_children():
		max_height_in_row = max(max_height_in_row, c.size.y, c.scale.y)
		
		if c.size.x * c.scale.x + row_fill > size.x :
			row_fill = 0
			column_fill += max_height_in_row
			max_height_in_row = 0
		
		c.position.x = row_fill
		c.position.y = column_fill
		
		row_fill += c.size.x * c.scale.x
	
#		print("moving child: ", c, " to location: (", row_fill, ", ", column_fill, ")")

func _get_minimum_size():
	var min_size:Vector2 = Vector2.ZERO
	for c in get_children():
		min_size.x = max(min_size.x, c.size.x * c.scale.x)
	min_size += Vector2.ONE
	return min_size
