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
		
		# 1. Update health ONLY ONCE via the helper method
		Data.update_health(-1)
		
		var current_hp = Data.save_data.get("current_health", 0)
		print("Remaining HP: ", current_hp)
		
		# 2. Check HP state
		if current_hp > 0:
			# Player is ALIVE: Respawn at local ground checkpoint
			body.global_position = Data.get_last_safe_position()
		else:
			# Player is DEAD: Respawn at Shrine coordinates
			print("Player Died -> Teleporting to Shrine: ", Data.get_last_shrine_position())
			body.global_position = Data.get_last_shrine_position()
			
			# Restore HP back to 3 and refresh UI hearts
			Data.save_data["current_health"] = 3
			Data.update_health(0) # Triggers signal refresh without altering HP
		
		# 3. Stop physics momentum immediately
		if "motion" in body:
			body.motion = Vector2.ZERO
		elif body.has_method("reset_velocity"):
			body.reset_velocity()
			
		if not first_fall:
			first_fall = true
	if body.name == "Player":
		print("Player fell!")
		
		# 1. Deduct 1 HP and emit health update signal
		Data.update_health(-1)
		
		var current_hp = Data.save_data.get("current_health", 0)
		
		# 2. Check HP state
		if current_hp > 0:
			# Player is ALIVE: Respawn at local ground checkpoint
			body.global_position = Data.get_last_safe_position()
		else:
			# Player is DEAD: Respawn at Shrine coordinates
			print("Player Died -> Teleporting to Shrine: ", Data.get_last_shrine_position())
			body.global_position = Data.get_last_shrine_position()
			
			# Restore HP back to max (3) and emit signal to update UI hearts
			Data.update_health(3)
		
		# 3. Stop physics momentum (prevents falling speed carrying over after teleport)
		if "motion" in body:
			body.motion = Vector2.ZERO
		elif body.has_method("reset_velocity"):
			body.reset_velocity()
			
		if not first_fall:
			first_fall = true
	if body.name == "Player":
		print("Player fell!")
		
		# 1. Deduct HP using your update helper
		var current_hp = Data.save_data.get("current_health", 3) - 1
		Data.save_data["current_health"] = current_hp
		Data.update_health()
		
		# 2. Check HP state
		if current_hp > 0:
			# Respawn at safe ground
			body.global_position = Data.get_last_safe_position()
		else:
			# Respawn at Shrine
			var shrine_target = Data.get_last_shrine_position()
			print("teleporting to shrine at: ", shrine_target)
			
			body.global_position = shrine_target
			print("teleported at: ", body.global_position)
			
			# CRITICAL: Restore health on death so player isn't stuck dead
			Data.save_data["current_health"] = 3
			Data.update_health()
		
		# 3. Reset physics velocity
		if "motion" in body:
			body.motion = Vector2.ZERO
		elif body.has_method("reset_velocity"):
			body.reset_velocity()
			
		if not first_fall:
			first_fall = true
	print(Data.get_last_shrine_position())
	if body.name == "Player":
		print("Player fell!")
		Data.save_data["current_health"] -= 1
		Data.update_health()
		# Reset the player's position to the last safe checkpoint
		if Data.save_data.get("current_health", 0) > 0:
			body.global_position = Data.get_last_safe_position()
		else:
			print("teleporting to: ", Data.get_last_shrine_position())
			body.global_position = Data.get_last_shrine_position()
			print("teleported at: ", body.global_position)
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
