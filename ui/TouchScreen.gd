extends CanvasLayer

func _ready():
	$PausePopup.visible = false
	$PausePopup/HBoxContainer/Settings/Settings.visible = false
	$PausePopup/HBoxContainer/Quit/QuitConfirmationPopup.visible = false
	$DataCodexPopup.visible = false
	
	$"ControlButtons/Data Codex".visible = false
	if Data.save_data.get("ach") and "Data Codex" in Data.save_data["ach"]:
		$"ControlButtons/Data Codex".visible = true

func _on_Pause_pressed():
	get_tree().paused = true
	$ControlButtons.visible = false
	$PausePopup.visible = true
	$Profile.visible = false

func _on_Resume_button_up():
	get_tree().paused = false
	$ControlButtons.visible = true
	$PausePopup.visible = false
	$Profile.visible = true

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
		print("The game was paused!")
		_save_player_position()
		
	elif what == NOTIFICATION_UNPAUSED:
		print("The game was resumed!")

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
