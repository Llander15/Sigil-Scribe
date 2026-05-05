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


func _on_Pause_released():
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
