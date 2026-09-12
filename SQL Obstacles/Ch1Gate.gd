extends Node2D

var target_player = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		target_player = body
		
		var interact_node = body.get_node_or_null("Control/TouchScreen/ControlButtons/Interact")
		if interact_node:
			interact_node.visible = true
		
		if not body.is_connected("interact_pressed", self, "_on_player_interacted"):
			body.connect("interact_pressed", self, "_on_player_interacted")

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		var interact_node = body.get_node_or_null("Control/TouchScreen/ControlButtons/Interact")
		if interact_node:
			interact_node.visible = false
		
		if body.is_connected("interact_pressed", self, "_on_player_interacted"):
			body.disconnect("interact_pressed", self, "_on_player_interacted")
			
		target_player = null

func _on_player_interacted():
	print("Player touched the terminal!")
	$Popup.visible = true
	get_tree().paused = true
	
	if target_player and is_instance_valid(target_player):
		var touch_screen = target_player.get_node_or_null("Control/TouchScreen")
		if touch_screen:
			touch_screen.visible = false
