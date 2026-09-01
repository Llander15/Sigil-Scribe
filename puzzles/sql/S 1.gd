extends Node2D

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

func _ready():
	$Popup.visible = false
	$Popup/NinePatchRect/Table.visible = false
	$Popup/Back.visible = false
	
	updateAns()
	
	# Tutorial start
	$Popup/tutorial/t1.visible = true
	$Popup/exit.hide()
	
	_ensure_achievements_array()
	
	if "S 1" in Data.save_data["ach"]:
		puzzleSolved = true
		if has_node("Area2D/Sprite"):
			$Area2D/Sprite.visible = false

func _on_Area2D_body_entered(body):
	if puzzleSolved:
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
	print("Player touched the terminal!")
	$Popup.visible = true
	get_tree().paused = true
	
	if target_player and is_instance_valid(target_player):
		var touch_screen = target_player.get_node_or_null("Control/TouchScreen")
		if touch_screen:
			touch_screen.visible = false

func _on_exit_released():
	exit_puzzle()

func exit_puzzle():
	$Popup.visible = false
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
	
	if $Popup/tutorial/t2.visible:
		$Popup/tutorial/t2.visible = false
		$Popup/tutorial/t3.visible = true

func _on_Back_pressed():
	$Popup/NinePatchRect/Table.visible = false
	$Popup/Back.visible = false
	
	$Popup/Table.visible = true
	$Popup/Confirm.visible = true
	$Popup/NinePatchRect/Terminal.visible = true
	
	$Popup/tutorial/t4.visible = true

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		updateAns()

func updateAns():
	if S1 and S2 and S3 and S4 and S5:
		currentAns = str(S1.sql_text) + " " + str(S2.sql_text) + " " + str(S3.sql_text) + " " + str(S4.sql_text) + " " + str(S5.sql_text)
		if currentAns == correctAns:
			$Popup/Confirm.disabled = false
			if $Popup/tutorial/t4.visible:
				$Popup/tutorial/t4.visible = false
				$Popup/tutorial/t5.visible = true
		else:
			$Popup/Confirm.disabled = true

func puzzleSolve():
	_ensure_achievements_array()
	if not "S 1" in Data.save_data["ach"]:
		Data.save_data["ach"].append("S 1")
		# FIXED: Matched save call with baseline Data.gd
		Data.save_game()

func _on_Confirm_pressed():
	puzzleSolve()
	puzzleSolved = true
	if has_node("Area2D/Sprite"):
		$Area2D/Sprite.visible = false
	
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
	
	if not "Logic Gauntlet" in Data.save_data["ach"]:
		Data.save_data["ach"].append("Logic Gauntlet")
	if not "Data Codex" in Data.save_data["ach"]:
		Data.save_data["ach"].append("Data Codex")
	
	# FIXED: Save to disk and check cloud sync status automatically
	Data.save_game()
	
	exit_puzzle()
	$Popup2.visible = false
	
	get_tree().reload_current_scene()

func _on_Button_pressed():
	$Popup/tutorial/t1.visible = false
	$Popup/tutorial/t2.visible = true

func _on_t3button_pressed():
	$Popup/tutorial/t3.visible = false

func _ensure_achievements_array():
	if not Data.save_data.has("ach") or not (Data.save_data["ach"] is Array):
		Data.save_data["ach"] = []
