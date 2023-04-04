extends Area2D

@export_file("*.tscn") var location:String 

func _on_body_entered(body):
	if body is Player:
		get_tree().call_group(&"overworld", &"transition", load(location))
