extends Node

var first_fall = false

func _ready():
	if Data.save_data["last_safe_position"]:
		pass
	else:
		Data.save_data["last_safe_position"] = $"../Player".global_position
	pass # Replace with function body.

func player_fell(body):
	if body.name == "Player":
		# 1. Play a sound or screen fade (Optional)
		print("Player fell!")
		
		# 2. Reset the player's position to the last checkpoint
		body.global_position = Data.save_data["last_safe_position"]
		
		# 3. Reset velocity so they don't keep "falling" after teleporting
		if body.has_method("reset_velocity"):
			body.reset_velocity()
		if !first_fall:
			#falling tutorial
			pass
	pass # Replace with function body.


func _on_Area2D0_body_entered(body):
	player_fell(body)
	pass # Replace with function body.


func _on_Area2D1_body_entered(body):
	player_fell(body)
	pass # Replace with function body.


func _on_Area2D2_body_entered(body):
	player_fell(body)
	pass # Replace with function body.
