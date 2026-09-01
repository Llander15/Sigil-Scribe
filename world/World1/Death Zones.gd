extends Node

var first_fall = false

func _ready():
	var safe_pos = Data.get_last_safe_position()
	
	# If the position is unset (Vector2.ZERO) and Player node exists, initialize it
	if safe_pos == Vector2.ZERO and has_node("../Player"):
		var player = get_node("../Player")
		# FIXED: Matched function name with baseline Data.gd
		Data.set_last_safe_position(player.global_position)
		Data.save_game()

func player_fell(body):
	if body.name == "Player":
		print("Player fell!")
		
		# Reset the player's position to the last safe checkpoint
		body.global_position = Data.get_last_safe_position()
		
		# Reset velocity so the player stops accelerating downwards
		if "motion" in body:
			body.motion = Vector2.ZERO
		elif body.has_method("reset_velocity"):
			body.reset_velocity()
			
		if not first_fall:
			# Falling tutorial logic trigger
			first_fall = true

func _on_Area2D0_body_entered(body):
	player_fell(body)

func _on_Area2D1_body_entered(body):
	player_fell(body)

func _on_Area2D2_body_entered(body):
	player_fell(body)
