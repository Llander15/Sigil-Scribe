extends Node2D

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		# 1. Get the specific node that has the "signal interact_pressed"
		# Based on your previous code, it's the CanvasLayer named "Control"
		var ui_node = body.get_node("Control") 
		
		# 2. Show the button
		ui_node.get_node("TouchScreen/Interact").visible = true
		
		# 3. Connect to the UI_NODE, not the body
		if not ui_node.is_connected("interact_pressed", self, "_on_player_interacted"):
			ui_node.connect("interact_pressed", self, "_on_player_interacted")

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		var ui_node = body.get_node("Control")
		ui_node.get_node("TouchScreen/Interact").visible = false
		
		# 4. Disconnect from the UI_NODE
		if ui_node.is_connected("interact_pressed", self, "_on_player_interacted"):
			ui_node.disconnect("interact_pressed", self, "_on_player_interacted")
			
# This runs when the signal is received
func _on_player_interacted():
	print("Player touched the terminal!")
