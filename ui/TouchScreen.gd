extends CanvasLayer

onready var hearts_container = $Hearts #HBoxContainer
onready var heart_1 = $Hearts/Heart1 #Control that have Sprite as a child
onready var heart_2 = $Hearts/Heart2
onready var heart_3 = $Hearts/Heart3

func _update_heart_output():
	var hp = int(Data.save_data.get("current_health", 3))
	
	heart_1.modulate = Color(1, 1, 1) if hp >= 1 else Color(0, 0, 0)
	heart_2.modulate = Color(1, 1, 1) if hp >= 2 else Color(0, 0, 0)
	heart_3.modulate = Color(1, 1, 1) if hp >= 3 else Color(0, 0, 0)
	
	if hp <= 0 and $"../..".name == "Player":
		$"../..".global_position = Data.get_last_shrine_position()
		print("Player Died")

func _ready():
	$PausePopup.visible = false
	$PausePopup/HBoxContainer/Settings/Settings.visible = false
	$PausePopup/HBoxContainer/Quit/QuitConfirmationPopup.visible = false
	$DataCodexPopup.visible = false
	
	$"ControlButtons/Data Codex".visible = false
	if Data.save_data.get("ach") and "Data Codex" in Data.save_data["ach"]:
		$"ControlButtons/Data Codex".visible = true
	
	# Safely connect the global signal to local function
	if Data.has_signal("health_updated"):
		if not Data.is_connected("health_updated", self, "_update_heart_output"):
			Data.connect("health_updated", self, "_update_heart_output")
	_update_heart_output()

func _on_Pause_pressed():
	get_tree().paused = true
	$ControlButtons.visible = false
	$PausePopup.visible = true


func _on_Resume_button_up():
	get_tree().paused = false
	$ControlButtons.visible = true
	$PausePopup.visible = false

func _on_Settings_button_up():
	$PausePopup/HBoxContainer/Settings/Settings.visible = true

func _on_Quit_button_up():
	$PausePopup/HBoxContainer/Quit/QuitConfirmationPopup.visible = true

func _on_Confirm_button_up():
	get_tree().paused = false
	get_tree().call_deferred("change_scene", "res://Welcome.tscn")

func _on_Cancel_button_up():
	$PausePopup/HBoxContainer/Quit/QuitConfirmationPopup.visible = false

func _notification(what):
	# Triggers when the user minimizes the app or opens another app
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT or what == MainLoop.NOTIFICATION_APP_PAUSED:
		if not get_tree().paused:
			get_tree().paused = true
			$ControlButtons.visible = false
			$PausePopup.visible = true
		
	if what == NOTIFICATION_PAUSED:
		$ControlButtons.visible = false
		$Hearts.visible = false
		_save_player_position()
		
	elif what == NOTIFICATION_UNPAUSED:
		$ControlButtons.visible = true
		$Hearts.visible = true

func _save_player_position():
	# Access grandparent node safely
	var player = get_parent().get_parent()
	if player and player.name == "Player": 
		var player_pos = player.global_position
		
		# FIXED: Matched function names with baseline Data.gd
		Data.set_last_safe_position(player_pos)
		Data.set_player_position(player_pos)
		Data.save_game()
		
		print("Player position updated to: ", player_pos)
	else:
		print("Player position update failed: Grandparent is not 'Player'")

func _on_Book_pressed():
	if Data.save_data.get("ach") and "Data Codex" in Data.save_data["ach"]:
		$DataCodexPopup.visible = true
		get_tree().paused = true

