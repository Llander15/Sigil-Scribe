extends Node2D

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		# Update last_safe_position & player_position in save_data
		Data.set_last_safe_position(global_position)
		Data.set_player_position(global_position)
		
		# Persist data to file (essential for mobile pause/close)
		Data.save_game()
		
		print("Checkpoint & Player position saved at: ", global_position)
