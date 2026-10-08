extends Node2D

export(Array, int) var target_mission_numbers = [-1]
var interactable = false
onready var POPUP = $Popup

func _on_mission_updated(new_mission: int):
	check_mission_importance()

func check_mission_importance():
	var current_mission = int(Data.save_data.get("mission_number", -1))
	
	# Checks if current_mission matches ANY number in target_mission_numbers
	if current_mission in target_mission_numbers:
		if has_node("Area2D/Sprite"):
			$Area2D/Sprite.visible = true
		interactable = true
	elif Data.save_data["mission_number"] < target_mission_numbers[0]:
		if has_node("Area2D/Sprite"):
			$Area2D/Sprite.visible = false
		interactable = false

var target_player = null
var puzzle_start = false
var solved = false

#PUZZLE
onready var s1 = $"Popup/NinePatchRect/Sources/Source 1"
onready var s2 = $"Popup/NinePatchRect/Sources/Source 2"
onready var s3 = $"Popup/NinePatchRect/Sources/Source 3"

onready var w1 = $"Popup/NinePatchRect/Wires/Wire 1"
onready var w2 = $"Popup/NinePatchRect/Wires/Wire 2"
onready var w3 = $"Popup/NinePatchRect/Wires/Wire 3"
onready var w4 = $"Popup/NinePatchRect/Wires/Wire 4"
onready var w5 = $"Popup/NinePatchRect/Wires/Wire 5"
onready var w6 = $"Popup/NinePatchRect/Wires/Wire 6"

onready var g1 = $"Popup/NinePatchRect/Gates/Gate 1"
onready var g2 = $"Popup/NinePatchRect/Gates/Gate 2"
onready var g3 = $"Popup/NinePatchRect/Gates/Gate 3"
onready var g4 = $"Popup/NinePatchRect/Gates/Gate 4"
onready var g5 = $"Popup/NinePatchRect/Gates/Gate 5"
onready var g6 = $"Popup/NinePatchRect/Gates/Gate 6"
onready var g7 = $"Popup/NinePatchRect/Gates/Gate 7"

onready var f1 = $"Popup/NinePatchRect/Final/Final 1"
#PREVIEW
onready var ps1 = $"Preview/NinePatchRect/Sources/Source 1"
onready var ps2 = $"Preview/NinePatchRect/Sources/Source 2"
onready var ps3 = $"Preview/NinePatchRect/Sources/Source 3"

onready var pw1 = $"Preview/NinePatchRect/Wires/Wire 1"
onready var pw2 = $"Preview/NinePatchRect/Wires/Wire 2"
onready var pw3 = $"Preview/NinePatchRect/Wires/Wire 3"
onready var pw4 = $"Preview/NinePatchRect/Wires/Wire 4"
onready var pw5 = $"Preview/NinePatchRect/Wires/Wire 5"
onready var pw6 = $"Preview/NinePatchRect/Wires/Wire 6"

onready var pg1 = $"Preview/NinePatchRect/Gates/Gate 1"
onready var pg2 = $"Preview/NinePatchRect/Gates/Gate 2"
onready var pg3 = $"Preview/NinePatchRect/Gates/Gate 3"
onready var pg4 = $"Preview/NinePatchRect/Gates/Gate 4"
onready var pg5 = $"Preview/NinePatchRect/Gates/Gate 5"
onready var pg6 = $"Preview/NinePatchRect/Gates/Gate 6"
onready var pg7 = $"Preview/NinePatchRect/Gates/Gate 7"

onready var pf1 = $"Preview/NinePatchRect/Final/Final 1"

func _ready():
	$Preview.visible = false
	$Popup.visible = false
	if "LG_8" in Data.save_data["puzzles_solved"]:
		_puzzle_solved()
	else:
		$Gate/Bars/AnimatedSprite.play("close")
		$Gate/Bars/StaticBody2D/CollisionShape2D.disabled = false
	
	yield(get_tree(), "idle_frame")
	setup_handshakes()

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
	#preview
	ps1.connect("signal_updated", pg1, "_on_input_a_received")
	ps1.connect("signal_updated", pw1, "_on_signal_received")

	ps2.connect("signal_updated", pg1, "_on_input_b_received")
	ps2.connect("signal_updated", pw2, "_on_signal_received")

	ps3.connect("signal_updated", pg2, "_on_input_a_received")
	ps3.connect("signal_updated", pw3, "_on_signal_received")

	pg1.connect("signal_updated", pg3, "_on_input_a_received")
	pg1.connect("signal_updated", pw4, "_on_signal_received")

	pg2.connect("signal_updated", pg3, "_on_input_b_received")
	pg2.connect("signal_updated", pw5, "_on_signal_received")

	pg3.connect("signal_updated", pf1, "_on_signal_received")
	pg3.connect("signal_updated", pw6, "_on_signal_received")

	ps1.update_logic()
	ps2.update_logic()
	ps3.update_logic()
	
	if Data.has_signal("mission_updated"):
		if not Data.is_connected("mission_updated", self, "_on_mission_updated"):
			Data.connect("mission_updated", self, "_on_mission_updated")
	check_mission_importance()

func _on_Area2D_body_entered(body):
	if Data.save_data["mission_number"] < target_mission_numbers[0]:
		return
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

func _on_player_interacted():
	POPUP.visible = true
	puzzle_start = true
	
	get_tree().paused = true
	target_player.get_node("Control/TouchScreen").visible = false

func _on_exit_released():
	exit_puzzle()

func exit_puzzle():
	$Preview.visible = false
	$Popup.visible = false
	puzzle_start = false
	get_tree().paused = false
	
	if target_player:
		target_player.get_node("Control/TouchScreen").visible = true
		target_player.get_node("Control/TouchScreen/ControlButtons/Interact").visible = false

func _on_confirm_pressed():
	if g1.LogicGate == "" or g2.LogicGate == "" or g3.LogicGate == "":
		$Popup/InstructionLabel.text = "Fill in all blank slots first."
		$Popup/InstructionLabel/AnimationPlayer.stop()
		$Popup/InstructionLabel/AnimationPlayer.play("in_out")
		return
	get_tree().get_root().set_disable_input(true)
	
	w1.confirm_state()
	w2.confirm_state()
	w3.confirm_state()
	w4.confirm_state()
	w5.confirm_state()
	w6.confirm_state()
	
	f1.confirm_state()
	
	var is_correct = yield(f1, "evaluation_completed")
	
	if is_correct:
		if not "LG_8" in Data.save_data["puzzles_solved"]:
			Data.save_data["puzzles_solved"].append("LG_8")
		
		if f1.transition_time > 0.0:
			yield(get_tree().create_timer(f1.transition_time + f1.delay + 0.5), "timeout")
		exit_puzzle()
		yield(get_tree().create_timer(2), "timeout")
		$Gate/Bars/AnimatedSprite.play("closing_animation")
		yield($Gate/Bars/AnimatedSprite, "animation_finished")
		$Gate/Bars/AnimatedSprite.play("open")
		$Gate/Bars/StaticBody2D/CollisionShape2D.disabled = true
		_puzzle_solved()
	else:
		$Popup/InstructionLabel.text = "Incorrect logic, try again."
		$Popup/InstructionLabel/AnimationPlayer.stop()
		$Popup/InstructionLabel/AnimationPlayer.play("in_out")
		Data.update_health(-1)
		var current_health = Data.save_data.get("current_health", 3)
		if current_health <= 0:
			exit_puzzle()
	
	get_tree().get_root().set_disable_input(false)

func _puzzle_solved():
	POPUP = $Preview
	$Gate/Bars/AnimatedSprite.play("open")
	$Gate/Bars/StaticBody2D/CollisionShape2D.disabled = true
	
	$Area2D/Sprite.visible = true
	$Area2D/Sprite.scale = Vector2(0.5, 0.5)
	$Area2D/Sprite/AnimationPlayer.play("floating")
	
	var current_mission = Data.save_data.get("mission_number", -1)
	if current_mission == 10:
		Data.advance_mission()
	exit_puzzle()

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		pass
	
	if what == NOTIFICATION_DRAG_BEGIN:
		pass
