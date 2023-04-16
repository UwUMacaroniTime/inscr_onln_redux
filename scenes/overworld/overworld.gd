extends Node2D

@onready var player = $Player

func transition(new_location:PackedScene, position_group:StringName):
	var animator:AnimationPlayer = $AnimationPlayer
	animator.play("fade_out")
	
	await animator.animation_finished
	
	get_tree().call_group(&"location", &"queue_free")
	add_child(new_location.instantiate())
	player.position = get_tree().get_first_node_in_group(position_group).get_global_transform().origin
	
	animator.play_backwards("fade_out")
