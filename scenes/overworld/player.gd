class_name Player
extends CharacterBody2D

var speed = 50.0

func _physics_process(delta):
	# Add the gravity.
	
	velocity = Input.get_vector("player_left", "player_right", "player_up", "player_down") * speed
	
	move_and_slide()
