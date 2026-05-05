extends Node2D

var target_player = null
var puzzle_start = false
var solved = false


var s1
var s2 
var s3

var w1
var w2
var w3 
var w4
var w5
var w6

var g1 
var g2 
var g3

var f1 

func _ready():
	$Popup.visible = false
	
	s1 = $"Popup/NinePatchRect/Sources/Source 1"
	s2 = $"Popup/NinePatchRect/Sources/Source 2"
	s3 = $"Popup/NinePatchRect/Sources/Source 3"
	
	w1 = $"Popup/NinePatchRect/Wires/Wire 1"
	w2 = $"Popup/NinePatchRect/Wires/Wire 2"
	w3 = $"Popup/NinePatchRect/Wires/Wire 3"
	w4 = $"Popup/NinePatchRect/Wires/Wire 4"
	w5 = $"Popup/NinePatchRect/Wires/Wire 5"
	w6 = $"Popup/NinePatchRect/Wires/Wire 6"
	
	g1 = $"Popup/NinePatchRect/Gates/Gate 1"
	g2 = $"Popup/NinePatchRect/Gates/Gate 2"
	g3 = $"Popup/NinePatchRect/Gates/Gate 3"
	
	f1 = $"Popup/NinePatchRect/Final/Final 1"
	
	yield(get_tree(), "idle_frame")
	setup_handshakes()
	$Bridge/Sprite.visible = false
	$Bridge/StaticBody2D/CollisionShape2D.disabled = true
	pass

func setup_handshakes():
	s1.connect("signal_updated", g1, "_on_input_a_received")
	s1.connect("signal_updated", w1, "_on_signal_received")
	

	s2.connect("signal_updated", g1, "_on_input_b_received")
	s2.connect("signal_updated", w2, "_on_signal_received")
	
	s3.connect("signal_updated", g2, "_on_input_a_received")
	s3.connect("signal_updated", w3, "_on_signal_received")
	

	g1.connect("signal_updated", g3, "_on_input_a_received")
	g1.connect("signal_updated", w4, "_on_signal_received")
	
	g2.connect("signal_updated", g3, "_on_input_b_received")
	g2.connect("signal_updated", w5, "_on_signal_received")
	
	g3.connect("signal_updated", f1, "_on_signal_received")
	g3.connect("signal_updated", w6, "_on_signal_received")
	

	s1.update_logic()
	s2.update_logic()
	s3.update_logic()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		
		target_player = body
		
		body.get_node("Control/TouchScreen/ControlButtons/Interact").visible = true
		
		if not body.is_connected("interact_pressed", self, "_on_player_interacted"):
			body.connect("interact_pressed", self, "_on_player_interacted")

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		
		target_player = null
		
		body.get_node("Control/TouchScreen/ControlButtons/Interact").visible = false
		
		if body.is_connected("interact_pressed", self, "_on_player_interacted"):
			body.disconnect("interact_pressed", self, "_on_player_interacted")
		pass

# This runs when the signal is received
func _on_player_interacted():
	print("Player touched the terminal!")
	
	$Popup.visible = true
	puzzle_start = true
	
	#freezes the world
	get_tree().paused = true
	
	target_player.get_node("Control/TouchScreen").visible = false

func _on_exit_released():
	exit_puzzle()
	pass # Replace with function body.

func exit_puzzle():
	$Popup.visible = false
	puzzle_start = false
	
	#Unfreeze the world
	get_tree().paused = false
	
	if not target_player:
		pass
	else:
		target_player.get_node("Control/TouchScreen").visible = true
		target_player.get_node("Control/TouchScreen/ControlButtons/Interact").visible = false

func _on_confirm_released():
	if puzzle_start:
		if $"Popup/NinePatchRect/Final/Final 1".solved:
			$Bridge/StaticBody2D/CollisionShape2D.disabled = false
			$Bridge/Sprite.visible = true
			$Area2D/before.visible = false
			$Area2D/after.visible = true
			$Area2D/CollisionShape2D.disabled = true
			exit_puzzle()
	pass # Replace with function body.
