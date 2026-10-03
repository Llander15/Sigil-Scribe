extends CanvasLayer

func _ready():
	$PausePopup.visible = false
	$PausePopup/HBoxContainer/Settings/Settings.visible = false
	$PausePopup/HBoxContainer/Quit/QuitConfirmationPopup.visible = false
	$DataCodexPopup.visible = false
	
	$"ControlButtons/Data Codex".visible = false
	if Data.save_data.get("ach") and "Data Codex" in Data.save_data["ach"]:
		$"ControlButtons/Data Codex".visible = true
	
	$MovementTutorial.visible = false
	$InteractTutorial.visible = false
	if not Data.save_data["tutorials"]["movement"]:
		_play_movement_tutorial()

func _play_movement_tutorial():
	$MovementTutorial.visible = true
	
	$InteractTutorial.visible = false
	
	$TutorialPlayer.play("Play_Movement_Tutorial")
	yield($TutorialPlayer, "animation_finished")
	$MovementTutorial.visible = false
	Data.save_data["tutorials"]["movement"] = true

func play_interact_tutorial():
	Input.action_release("ui_right")
	Input.action_release("ui_left")
	
	$InteractTutorial.visible = true
	
	$MovementTutorial.visible = false
	
	$TutorialPlayer.play("Play_Interact_Tutorial")
	yield($TutorialPlayer, "animation_finished")
	$InteractTutorial.visible = false
	Data.save_data["tutorials"]["npc"] = true
	
	#if interact interupted the movement tutorialz
	if not Data.save_data["tutorials"]["movement"]:
		Data.save_data["tutorials"]["movement"] = true

func _play_death_screen():
	$DeathScreen/AnimationPlayer.play("dead")

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
		
		if $TutorialPlayer.is_playing():
			$TutorialPlayer.playback_active = false
			$MovementTutorial.visible = false
			$InteractTutorial.visible = false
		
	elif what == NOTIFICATION_UNPAUSED:
		$ControlButtons.visible = true
		$Hearts.visible = true
		
		if $TutorialPlayer.current_animation == "Play_Movement_Tutorial":
			$TutorialPlayer.playback_active = true
			$MovementTutorial.visible = true
		elif $TutorialPlayer.current_animation == "Play_Interact_Tutorial":
			$TutorialPlayer.playback_active = true
			$InteractTutorial.visible = true

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



func _on_Interact_pressed():
	$TutorialPlayer.play("RESET")
	$MovementTutorial.visible = false
	$InteractTutorial.visible = false
	#if npc interact is interupted
	if not Data.save_data["tutorials"]["npc"]:
		Data.save_data["tutorials"]["npc"] = true
	
	#if interact interupted the movement tutorialz
	if not Data.save_data["tutorials"]["movement"]:
		Data.save_data["tutorials"]["movement"] = true
	pass # Replace with function body.
