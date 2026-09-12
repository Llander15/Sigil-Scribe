extends Node2D

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		Data.set_last_safe_position(body.global_position) # SAFE POSITION ONLY
		
		print("Safe position updated to: ", body.global_position)
