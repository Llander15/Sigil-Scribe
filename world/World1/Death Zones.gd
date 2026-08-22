extends Node

var first_fall = false

func _ready():
	var safe_pos = Data.get_last_safe_position()
	
	# If the position is unset (Vector2.ZERO) and Player node exists, initialize it
	if safe_pos == Vector2.ZERO and has_node("../Player"):
		Data.set_last_safe_position($"../Player".global_position)

func player_fell(body):
	if body.name == "Player":
		# 1. Play a sound or screen fade (Optional)
		print("Player fell!")
		
		# 2. Reset the player's position to the last checkpoint
		body.global_position = Data.get_last_safe_position()
		
		# 3. Reset velocity so they don't keep "falling" after teleporting
		if body.has_method("reset_velocity"):
			body.reset_velocity()
			
		if not first_fall:
			# falling tutorial
			first_fall = true

func _on_Area2D0_body_entered(body):
	player_fell(body)

func _on_Area2D1_body_entered(body):
	player_fell(body)

func _on_Area2D2_body_entered(body):
	player_fell(body)
