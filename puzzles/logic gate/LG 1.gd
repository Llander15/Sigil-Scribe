extends Node2D

var target_player = null

var s1
var s2 

var w1
var w2
var w3 

var g1 
var g2 

var f1 

func _ready():
	$Popup.visible = false
	
	s1 = $"Popup/NinePatchRect/Sources/Source 1"
	s2 = $"Popup/NinePatchRect/Sources/Source 2"
	
	w1 = $"Popup/NinePatchRect/Wires/Wire 1"
	w2 = $"Popup/NinePatchRect/Wires/Wire 2"
	w3 = $"Popup/NinePatchRect/Wires/Wire 3"
	
	g1 = $"Popup/NinePatchRect/Gates/Gate 1"
	g2 = $"Popup/NinePatchRect/Gates/Gate 2"
	
	f1 = $"Popup/NinePatchRect/Final/Final 1"
	
	yield(get_tree(), "idle_frame")
	setup_handshakes()
	

	pass



func setup_handshakes():
	# --- Connection Set 1: Top Path ---
	# Source 1 (Violet) -> Gate 1 (Input A) and Wire 1 (Visual)
	s1.connect("signal_updated", g1, "_on_input_a_received")
	s1.connect("signal_updated", w1, "_on_signal_received")
	
	# --- Connection Set 2: Bottom Path ---
	# Source 2 (Violet) -> Gate 1 (Input B) and Wire 2 (Visual)
	s2.connect("signal_updated", g1, "_on_input_b_received")
	s2.connect("signal_updated", w2, "_on_signal_received")
	
	# --- Connection Set 3: Final Path ---
	# Gate 1 (Middle) -> Final 1 (Huge Box) and Wire 3 (Visual)
	g1.connect("signal_updated", f1, "_on_signal_received")
	g1.connect("signal_updated", w3, "_on_signal_received")
	
	# --- Refresh Initial States ---
	# This forces the sources to 'shout' their start state once connected
	s1.update_logic()
	s2.update_logic()

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
	
	#Freeze the world
	get_tree().paused = true
	
	$Popup.visible = true
	
	
	
	target_player.get_node("Control/TouchScreen").visible = false

func _on_exit_released():
	exit_puzzle()
	pass # Replace with function body.


func exit_puzzle():
	$Popup.visible = false
	
	#Unfreeze the world
	get_tree().paused = false
	
	if not target_player:
		pass
	else:
		target_player.get_node("Control/TouchScreen").visible = true
		target_player.get_node("Control/TouchScreen/Interact").visible = false


