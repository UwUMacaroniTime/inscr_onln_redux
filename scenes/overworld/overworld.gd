extends Node2D

func transition(new_location:PackedScene):
	var animator:AnimationPlayer = $AnimationPlayer
	animator.play("fade_out")
	
	await animator.animation_finished
	
	get_tree().call_group(&"location", &"queue_free")
	add_child(new_location.instantiate())
	
	animator.play_backwards("fade_out")
