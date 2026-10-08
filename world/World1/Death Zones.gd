extends Node

var first_fall = false

func _ready():
	var safe_pos = Data.get_last_safe_position()
	
	# Initialize safe position if unset
	if safe_pos == Vector2.ZERO and has_node("../Player"):
		var player = get_node("../Player")
		Data.set_last_safe_position(player.global_position)
		Data.save_game()

func player_fell(body):
	if body.name != "Player":
		return
		
	print("Player fell!")
	
	# 1. Deduct 1 HP
	Data.save_data["current_health"] = Data.save_data.get("current_health", 3) - 1
	Data.update_health()
	
	var current_hp = Data.save_data["current_health"]
	print("Remaining HP: ", current_hp)
	
	# 2. Check HP State
	if current_hp > 0:
		# ALIVE: Respawn at local safe position
		body.global_position = Data.get_last_safe_position()
	else:
		# DEAD: Teleport to Shrine and reset HP back to 3
		print("Player Died -> Teleporting to Shrine: ", Data.get_last_shrine_position())
		body.global_position = Data.get_last_shrine_position()
		
		Data.save_data["current_health"] = 3
		Data.update_health()
	
	# 3. Stop physics momentum
	if "motion" in body:
		body.motion = Vector2.ZERO
	elif body.has_method("reset_velocity"):
		body.reset_velocity()
		
	if not first_fall:
		first_fall = true

func _on_Area2D0_body_entered(body):
	player_fell(body)

func _on_Area2D1_body_entered(body):
	player_fell(body)

func _on_Area2D2_body_entered(body):
	player_fell(body)
