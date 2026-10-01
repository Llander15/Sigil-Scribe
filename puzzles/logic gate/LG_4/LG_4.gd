extends Node2D

export(Array, int) var target_mission_numbers = [-1]
var interactable = false

func _on_mission_updated(new_mission: int):
	check_mission_importance()

func check_mission_importance():
	var current_mission = int(Data.save_data.get("mission_number", -1))
	
	# Checks if current_mission matches ANY number in target_mission_numbers
	if current_mission in target_mission_numbers:
		if has_node("Area2D/Sprite"):
			$Area2D/Sprite.visible = true
		interactable = true
	elif current_mission < target_mission_numbers[0]:
		if has_node("Area2D/Sprite"):
			$Area2D/Sprite.visible = false
		interactable = false
	else:
		_puzzle_solved_init()

var target_player = null
var puzzle_start = false
var solved = false

onready var s1 = $"Popup/NinePatchRect/Sources/Source 1"

onready var w1 = $"Popup/NinePatchRect/Wires/Wire 1"
onready var w2 = $"Popup/NinePatchRect/Wires/Wire 2"

onready var g1 = $"Popup/NinePatchRect/Gates/Gate 1"

onready var f1 = $"Popup/NinePatchRect/Final/Final 1"

onready var POPUP = $Popup

func _ready():
	POPUP.visible = false
	$Preview.visible = false
	
	if "LG_4" in Data.save_data["puzzles_solved"]:
		_puzzle_solved_init()
		POPUP = $Preview
	else:
		$Platform/AnimatedSprite.play("broken")
		$Platform/KinematicBody2D/CollisionShape2D.disabled = true
	
	yield(get_tree(), "idle_frame")
	setup_handshakes()

func setup_handshakes():
	s1.connect("signal_updated", g1, "_on_input_a_received")
	s1.connect("signal_updated", w1, "_on_signal_received")
	
	g1.connect("signal_updated", f1, "_on_signal_received")
	g1.connect("signal_updated", w2, "_on_signal_received")

	s1.update_logic()
	
	if Data.has_signal("mission_updated"):
		if not Data.is_connected("mission_updated", self, "_on_mission_updated"):
			Data.connect("mission_updated", self, "_on_mission_updated")
	check_mission_importance()

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

func _on_player_interacted():
	POPUP.visible = true
	puzzle_start = true
	
	#tutorial, going back to start
	if Data.save_data["tutorials"]["digital_logic"] == false:
		$Popup/confirm.disabled = true
		
		$Popup/Tutorial/t1.visible = true
		$Popup/Tutorial/t2.visible = false
		$Popup/Tutorial/t3.visible = false
		$Popup/Tutorial/t4.visible = false
		$Popup/Tutorial/t5.visible = false
		$Popup/Tutorial/t6.visible = false
		$Popup/Tutorial/t7.visible = false
		$Popup/Tutorial/t8.visible = false
		$Popup/Tutorial/t9.visible = false
	
	get_tree().paused = true
	target_player.get_node("Control/TouchScreen").visible = false

func _on_exit_released():
	exit_puzzle()

func exit_puzzle():
	POPUP.visible = false
	puzzle_start = false
	get_tree().paused = false
	
	if target_player:
		target_player.get_node("Control/TouchScreen").visible = true
		target_player.get_node("Control/TouchScreen/ControlButtons/Interact").visible = false

func _on_confirm_pressed():
	if g1.LogicGate == "":
		$Popup/InstructionLabel.text = "Fill in all blank slots first."
		$Popup/InstructionLabel/AnimationPlayer.stop()
		$Popup/InstructionLabel/AnimationPlayer.play("in_out")
		return
	get_tree().get_root().set_disable_input(true)
	
	w1.confirm_state()
	w2.confirm_state()
	
	f1.confirm_state()
	
	var is_correct = yield(f1, "evaluation_completed")
	
	if is_correct:
		$Area2D.visible = false
		$Area2D/CollisionShape2D.disabled = true
		yield(get_tree().create_timer(f1.transition_time + f1.delay + 0.5), "timeout")
		exit_puzzle()
		yield(get_tree().create_timer(2), "timeout")
		$Platform/AnimatedSprite.play("repair")
		yield($Platform/AnimatedSprite, "animation_finished")
		$Platform/AnimatedSprite.play("default")
		$Platform/KinematicBody2D/CollisionShape2D.disabled = false
		
		if not "LG_4" in Data.save_data["puzzles_solved"]:
			Data.save_data["puzzles_solved"].append("LG_4")
		
		Data.advance_mission()
#		if f1.transition_time > 0.0:
#			yield(get_tree().create_timer(f1.transition_time + f1.delay + 0.5), "timeout")
			
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

func _puzzle_solved_init():
	$Area2D/Sprite.visible = true
	$Area2D/Sprite.scale = Vector2(0.5, 0.5)
	$Area2D/Sprite/AnimationPlayer.play("floating")
	
	$Platform/AnimatedSprite.play("default")
	$Platform/KinematicBody2D/CollisionShape2D.disabled = false
	$Platform/AnimationPlayer.play("moving_platform")

func _puzzle_solved():
	$Area2D/Sprite.visible = true
	$Area2D/Sprite.scale = Vector2(0.5, 0.5)
	$Area2D/Sprite/AnimationPlayer.play("floating")
	
	$Platform/AnimatedSprite.play("default")
	$Platform/KinematicBody2D/CollisionShape2D.disabled = false
	$Platform/AnimationPlayer.play("moving_platform")
	exit_puzzle()

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		$Popup/Tutorial/t8/Timer.stop()
	
	if what == NOTIFICATION_DRAG_BEGIN:
		$Popup/Tutorial/t8/Timer.start()

func _on_t1alpha0Btn_pressed():
	$Popup/Tutorial/t1.visible= false
	$Popup/Tutorial/t2.visible = true
	pass # Replace with function body.

func _on_t2alpha0Btn_pressed():
	$Popup/Tutorial/t2.visible = false
	$Popup/Tutorial/t3.visible = true
	pass # Replace with function body.

func _on_t3alpha0Btn_pressed():
	$Popup/Tutorial/t3.visible = false
	$Popup/Tutorial/t4.visible = true
	pass # Replace with function body.

func _on_t4alpha0Btn_pressed():
	$Popup/Tutorial/t4.visible = false
	$Popup/Tutorial/t5.visible = true
	pass # Replace with function body.

func _on_t5alpha0Btn_pressed():
	$Popup/Tutorial/t5.visible = false
	$Popup/Tutorial/t6.visible = true
	pass # Replace with function body.


func _on_t6alpha0Btn_pressed():
	$Popup/Tutorial/t6.visible = false
	$Popup/Tutorial/t7.visible = true
	pass # Replace with function body.


func _on_t7alpha0Btn_pressed():
	$Popup/Tutorial/t7.visible = false
	$Popup/Tutorial/t8.visible = true
	$Popup/Tutorial/t8/Sprite/AnimationPlayer.play("drag_and_hold")
	pass # Replace with function body.


func _on_Timer_timeout():
	if $Popup/Tutorial/t8 and $Popup/Tutorial/t8.visible:
			$Popup/Tutorial/t8.visible = false
			$Popup/confirm.disabled = false
			if not Data.save_data["tutorials"]["digital_logic"]:
				Data.save_data["tutorials"]["digital_logic"] = true

func _process(delta):
	if "LG_4" in Data.save_data["puzzles_solved"]:
		$Area2D.position = $Platform/KinematicBody2D.position
