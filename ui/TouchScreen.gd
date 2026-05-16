extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$PausePopup.visible = false
	$PausePopup/HBoxContainer/Settings/Settings.visible = false
	$PausePopup/HBoxContainer/Quit/QuitConfirmationPopup.visible = false
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Pause_pressed():
	get_tree().paused = true
	$ControlButtons.visible = false
	$PausePopup.visible = true
	pass # Replace with function body.


func _on_Resume_button_up():
	get_tree().paused = false
	$ControlButtons.visible = true
	$PausePopup.visible = false
	pass # Replace with function body.


func _on_Settings_button_up():
	$PausePopup/HBoxContainer/Settings/Settings.visible = true
	pass # Replace with function body.


func _on_Quit_button_up():
	
	$PausePopup/HBoxContainer/Quit/QuitConfirmationPopup.visible = true
	pass # Replace with function body.


func _on_Confirm_button_up():
	get_tree().paused = false
	get_tree().change_scene("res://Welcome.tscn")
	pass # Replace with function body.


func _on_Cancel_button_up():
	$PausePopup/HBoxContainer/Quit/QuitConfirmationPopup.visible = false
	pass # Replace with function body.

func _notification(what):
	# Triggers when the user minimizes the app or opens another app
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT or what == MainLoop.NOTIFICATION_APP_PAUSED:
		get_tree().paused = true
		$ControlButtons.visible = false
		$PausePopup.visible = true
		
	if what == NOTIFICATION_PAUSED:
		print("The game was paused! Do something here.")
		var player = get_parent().get_parent() #get the grandparent
		if player.name == "Player": 
			var player_pos = player.global_position
			Data.save_data["player_position"]["x"] = player_pos.x
			Data.save_data["player_position"]["y"] = player_pos.y
			Data.save_game()
			print("player position updated")
			print("x" , Data.save_data["player_position"]["x"])
			print("y" , Data.save_data["player_position"]["y"])
		else:
			print("player position update failed")
		# Example: Lower the music volume or blur the screen
		
	elif what == NOTIFICATION_UNPAUSED:
		print("The game was resumed!")
		# Example: Restore music volume


