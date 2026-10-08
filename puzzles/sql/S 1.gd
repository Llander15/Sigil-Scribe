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

onready var S1 = $Popup/NinePatchRect/Terminal/HBoxContainer/S1
onready var S2 = $Popup/NinePatchRect/Terminal/HBoxContainer/S2
onready var S3 = $Popup/NinePatchRect/Terminal/HBoxContainer/S3
onready var S4 = $Popup/NinePatchRect/Terminal/HBoxContainer/S4
onready var S5 = $Popup/NinePatchRect/Terminal/HBoxContainer/S5

onready var instruction_label_player = $Popup/InstructionLabel/AnimationPlayer

func _ready():
	$Popup.visible = false
	$Preview.visible = false
	
	$Popup/NinePatchRect/Table.visible = false
	$Popup/Back.visible = false
	
	updateAns()
	
	# Tutorial start
	$Popup/tutorial/t1.visible = true
	
	_ensure_achievements_array()
	
	if "S 1" in Data.save_data["ach"]:
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
	#tutorial
	for t in $Popup/tutorial.get_children():
		if "visible" in t:
			t.visible = false
	if Data.save_data["tutorials"]["sql"] == false:
		$Popup/tutorial/t1.visible = true
	

func _on_exit_released():
	exit_puzzle()

func exit_puzzle():
	$Popup.visible = false
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
	
	if $Popup/tutorial/t3.visible:
		$Popup/tutorial/t3.visible = false
		$Popup/tutorial/t4.visible = true

func _on_Back_pressed():
	$Popup/NinePatchRect/Table.visible = false
	$Popup/Back.visible = false
	
	$Popup/Table.visible = true
	$Popup/Confirm.visible = true
	$Popup/NinePatchRect/Terminal.visible = true
	
	if Data.save_data["tutorials"]["sql"] == false:
		$Popup/tutorial/t4.visible = false
		$Popup/tutorial/t5.visible = true
		$Popup/tutorial/t5/AnimatedSprite/AnimationPlayer.play("drag and drop")

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		updateAns()

func updateAns():
	if S1 and S2 and S3 and S4 and S5:
		currentAns = str(S1.sql_text) + " " + str(S2.sql_text) + " " + str(S3.sql_text) + " " + str(S4.sql_text) + " " + str(S5.sql_text)

func puzzleSolve():
	if int(Data.save_data.get("mission_number", 0)) <= 1:
		Data.save_data["mission_number"] = 2
	
	_ensure_achievements_array()
	if not "S 1" in Data.save_data["ach"]:
		Data.save_data["ach"].append("S 1")
		Data.save_game()
	_ready()

func _on_Confirm_pressed():
	if S4.text == "":
		$Popup/InstructionLabel.text = "Fill in the blank blocks to confirm answer."
		instruction_label_player.stop()
		instruction_label_player.play("in_out")
		return
	if not currentAns == correctAns:
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
	$Popup2.visible = true

func _on_t3Button_pressed():
	if $Popup/tutorial/t3.visible:
		$Popup/tutorial/t3.visible = false

func _on_LG_Confirm_pressed():
	$"Popup2/Logic Gauntlet".visible = false
	$"Popup2/Data Codex".visible = true

func _on_DC_Confirm_pressed():
	_ensure_achievements_array()
	
	# 1. Update achievements
	if not "Logic Gauntlet" in Data.save_data["ach"]:
		Data.save_data["ach"].append("Logic Gauntlet")
	if not "Data Codex" in Data.save_data["ach"]:
		Data.save_data["ach"].append("Data Codex")
		
	# 2. Advance mission safely
	var current_mission = int(Data.save_data.get("mission_number", 0))
	if current_mission <= 1:
		if Data.has_method("advance_mission"):
			Data.advance_mission()
		else:
			Data.save_data["mission_number"] = 2
			Data.save_game()
	else:
		Data.save_game()
	
	# 3. Force emit signal so active NPCs in scene update immediately
	if Data.has_signal("mission_updated"):
		Data.emit_signal("mission_updated", int(Data.save_data["mission_number"]))
	
	# 4. Unpause tree FIRST so nodes resume physics and input processing
	get_tree().paused = false
	
	# 5. Hide puzzle UI windows
	$Popup2.visible = false
	
	# 6. Reset target player and touch controls
	if target_player and is_instance_valid(target_player):
		target_player.pause_mode = Node.PAUSE_MODE_INHERIT
		
		var touch_screen = target_player.get_node_or_null("Control/TouchScreen")
		if touch_screen:
			touch_screen.visible = true
			
		var interact_btn = target_player.get_node_or_null("Control/TouchScreen/ControlButtons/Interact")
		if interact_btn:
			interact_btn.visible = false
			
		if target_player.has_method("reset_player"):
			target_player.reset_player()
		else:
			target_player._ready()

func _on_Button_pressed():
	$Popup/tutorial/t1.visible = false
	$Popup/tutorial/t2.visible = true

func _on_t3button_pressed():
	$Popup/tutorial/t3.visible = false

func _ensure_achievements_array():
	if not Data.save_data.has("ach") or not (Data.save_data["ach"] is Array):
		Data.save_data["ach"] = []


func _on_t2_Button_pressed():
	$Popup/tutorial/t2.visible = false
	$Popup/tutorial/t3.visible = true


func _on_t4_Button_pressed():
	$Popup/tutorial/t4.visible = false


func _on_t5_Button_pressed():
	$Popup/tutorial/t5.visible = false
	Data.save_data["tutorials"]["sql"] = true


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
