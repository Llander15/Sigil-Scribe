extends Node2D

var puzzleSolved = false
var target_player = null

var tableUnlocked = false
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
	
	if "S 1" in Data.save_data["ach"]:
		puzzleSolved = true
		pass
	pass

func _on_Area2D_body_entered(body):
	if puzzleSolved:
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
	
	#un freeze the world
	get_tree().paused = false
	
	target_player.get_node("Control/TouchScreen").visible = true
	target_player.get_node("Control/TouchScreen/ControlButtons/Interact").visible = false
	pass

func _on_Table_pressed():
	$Popup/NinePatchRect/Table.visible = true
	$Popup/Back.visible = true
	
	$Popup/Table. visible = false
	$Popup/Confirm.visible = false
	$Popup/NinePatchRect/Terminal.visible = false
	pass # Replace with function body.

func _on_Back_pressed():
	$Popup/NinePatchRect/Table.visible = false
	$Popup/Back.visible = false
	
	$Popup/Table. visible = true
	$Popup/Confirm.visible = true
	$Popup/NinePatchRect/Terminal.visible = true
	pass # Replace with function body.

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		updateAns()
		pass

func updateAns():
	currentAns = str(S1.sql_text) + " " + str(S2.sql_text) + " " + str(S3.sql_text) + " " + str(S4.sql_text) + " " + str(S5.sql_text)
	if currentAns == correctAns:
		$Popup/Confirm.disabled = false
	else:
		$Popup/Confirm.disabled = true
	
	if currentAns == tableSyntax:
		tableUnlocked = true
	
	if tableUnlocked:
		$Popup/Table.disabled = false
	else:
		$Popup/Table.disabled = true
	
	print(currentAns)


func puzzleSolved():
	if not "S 1" in Data.save_data["ach"]:
		Data.save_data["ach"].append("S 1")
	


func _on_Confirm_pressed():
	puzzleSolved()
	puzzleSolved = true
	exit_puzzle()
	
	pass # Replace with function body.
