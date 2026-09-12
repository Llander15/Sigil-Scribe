extends Node2D

export var Shrine_no: int = 0

func _ready():
	var active_shrines = Data.save_data.get("shrines_activated", [])
	
	if Shrine_no in active_shrines:
		$Sprite.play("active")
	else:
		$Sprite.play("default")

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		$Sprite.play("active")
		
		# Heal player back to max health safely via signal
		if Data.save_data.get("current_health", 3) < 3:
			Data.save_data["current_health"] = 3
			if Data.has_method("update_health"):
				Data.update_health(0) # Triggers UI refresh signal cleanly
		
		# FIXED: Save the Shrine's exact position (Node2D), NOT the player's position!
		Data.set_last_shrine_position(global_position)
		
		# Ensure array key exists safely
		if not Data.save_data.has("shrines_activated") or not (Data.save_data["shrines_activated"] is Array):
			Data.save_data["shrines_activated"] = []
			
		# Add shrine ID if not already registered
		if not Shrine_no in Data.save_data["shrines_activated"]:
			Data.save_data["shrines_activated"].append(Shrine_no)
		
		# Save to disk ONCE
		Data.save_game()
		
		print("Shrine ", Shrine_no, " activated and saved at: ", global_position)
