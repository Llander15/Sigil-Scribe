extends Node2D

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		# FIXED: Use baseline set_last_safe_position
		Data.set_last_safe_position(global_position)
		
		# FIXED: Persist data using baseline save_game()
		Data.save_game()
		
		print("Checkpoint saved at: ", global_position)
