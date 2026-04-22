extends Node2D

var target_player = null

func _ready():
	$Popup.visible = false
	pass

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		
		target_player = body
		
		body.get_node("Control/TouchScreen/Interact").visible = true
		
		if not body.is_connected("interact_pressed", self, "_on_player_interacted"):
			body.connect("interact_pressed", self, "_on_player_interacted")


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		
		target_player = null
		
		body.get_node("Control/TouchScreen/Interact").visible = false
		
		if body.is_connected("interact_pressed", self, "_on_player_interacted"):
			body.disconnect("interact_pressed", self, "_on_player_interacted")
		pass

# This runs when the signal is received
func _on_player_interacted():
	print("Player touched the terminal!")
	
	$Popup.visible = true
	
	#freezes the world
	get_tree().paused = true
	
	target_player.get_node("Control/TouchScreen").visible = false

func _on_exit_released():
	exit_puzzle()
	pass # Replace with function body.


func exit_puzzle():
	$Popup.visible = false
	
	target_player.get_node("Control/TouchScreen").visible = true
	target_player.get_node("Control/TouchScreen/Interact").visible = false
	pass


