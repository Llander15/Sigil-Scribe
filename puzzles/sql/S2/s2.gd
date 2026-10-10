extends Node2D

export(Array, int) var target_mission_numbers = [1]
var interactable = false
onready var POPUP = $Popup

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

var puzzleSolved = false
var target_player = null

var currentAns

var tableSyntax = "SELECT * FROM chest ;"
var correctAns = "SELECT * FROM chest ;"

var ansBlocks = []

onready var instruction_label_player = $Popup/InstructionLabel/AnimationPlayer

func _ready():
	$Popup.visible = false
	if $Preview:
		$Preview.visible = false
	
	$Popup/NinePatchRect/Table.visible = false
	$Popup/Back.visible = false
	
	updateAns()
	
	if "s2" in Data.save_data["ach"]:
		if $Preview:
			POPUP = $Preview
		puzzleSolved = true
		if has_node("Area2D/Sprite"):
			$Area2D/Sprite.visible = true
			$Area2D/Sprite.scale = Vector2(0.5, 0.5)
			
	if Data.has_signal("mission_updated"):
		if not Data.is_connected("mission_updated", self, "_on_mission_updated"):
			Data.connect("mission_updated", self, "_on_mission_updated")
	
	check_mission_importance()

func _on_mission_updated(new_mission: int):
	check_mission_importance()

func _on_Area2D_body_entered(body):
	if Data.save_data["mission_number"] < target_mission_numbers[0]:
		return
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
	POPUP.visible = true
	if $Popup.visible:
		$Popup/NinePatchRect/Terminal.visible = true
		$Popup/Table.visible = true
	
		$Popup/NinePatchRect/Table.visible = false
		$Popup/Back.visible = false
		get_tree().paused = true
	
	
	
	if target_player and is_instance_valid(target_player):
		var touch_screen = target_player.get_node_or_null("Control/TouchScreen")
		if touch_screen:
			touch_screen.visible = false

func _on_exit_released():
	exit_puzzle()

func exit_puzzle():
	$Popup.visible = false
	if $Preview:
		$Preview.visible = false
	get_tree().paused = false
	
	if target_player and is_instance_valid(target_player):
		var touch_screen = target_player.get_node_or_null("Control/TouchScreen")
		if touch_screen:
			touch_screen.visible = true
		
		var interact_btn = target_player.get_node_or_null("Control/TouchScreen/ControlButtons/Interact")
		if interact_btn:
			interact_btn.visible = false

func _on_Table_pressed():
	$Popup/NinePatchRect/Table.visible = true
	$Popup/Back.visible = true
	
	$Popup/Table.visible = false
	$Popup/Confirm.visible = false
	$Popup/NinePatchRect/Terminal.visible = false

func _on_Back_pressed():
	$Popup/NinePatchRect/Table.visible = false
	$Popup/Back.visible = false
	
	$Popup/Table.visible = true
	$Popup/Confirm.visible = true
	$Popup/NinePatchRect/Terminal.visible = true

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		updateAns()

func updateAns():
	pass

func puzzleSolve():
	if int(Data.save_data.get("mission_number", 0)) <= 1:
		Data.save_data["mission_number"] = 2
	
	if not "s2" in Data.save_data["ach"]:
		Data.save_data["ach"].append("s2")
		Data.save_game()
	_ready()

func _on_Confirm_pressed():
	ansBlocks = [
			$Popup/NinePatchRect/Terminal/ScrollContainer/VBoxContainer/HBoxContainer3/S4.sql_text,
			$Popup/NinePatchRect/Terminal/ScrollContainer/VBoxContainer/HBoxContainer5/S4.sql_text
	]
	if "" in ansBlocks:
		$Popup/InstructionLabel.text = "Fill in the blank blocks to confirm answer."
		instruction_label_player.stop()
		instruction_label_player.play("in_out")
		return
	if not ansBlocks[0] == "status = 'unequipped'":
		$Popup/InstructionLabel.text = "Incorrect query, try another."
		instruction_label_player.stop()
		instruction_label_player.play("in_out")
		Data.update_health(-1)
		if Data.save_data["current_health"] <= 0:
			exit_puzzle()
		print("incorrect answer")
		return
	if not ansBlocks[1] == "status = 'equipped'":
		$Popup/InstructionLabel.text = "Incorrect query, try another."
		instruction_label_player.stop()
		instruction_label_player.play("in_out")
		Data.update_health(-1)
		if Data.save_data["current_health"] <= 0:
			exit_puzzle()
		print("incorrect answer")
		return
	
	puzzleSolve()
	puzzleSolved = true
	
	$Popup.visible = false
	
	# 2. Advance mission safely
	var current_mission = int(Data.save_data.get("mission_number", 0))
	if current_mission == target_mission_numbers[0]:
		Data.advance_mission()
	
	get_tree().paused = false
	exit_puzzle()

func _on_pTable_pressed():
	$Preview/NinePatchRect/Table.visible = true
	$Preview/Back.visible = true
	
	$Preview/Table.visible = false
	$Preview/Confirm.visible = false
	$Preview/NinePatchRect/Terminal.visible = false

func _on_pBack_pressed():
	$Preview/NinePatchRect/Table.visible = false
	$Preview/Back.visible = false
	
	$Preview/Table.visible = true
	$Preview/Confirm.visible = true
	$Preview/NinePatchRect/Terminal.visible = true
