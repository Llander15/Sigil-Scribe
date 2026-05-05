extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Quit Confirmation".visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_button_up():
	get_tree().change_scene("res://world/World1/World1.tscn")
	pass # Replace with function body.


func _on_Settings_button_up():
	$Settings.visible = true
	pass # Replace with function body.


func _on_Quit_button_up():
	$"Quit Confirmation".visible = true
	pass # Replace with function body.


func _on_Confirm_button_up():
	get_tree().quit()
	pass # Replace with function body.


func _on_Cancel_button_up():
	$"Quit Confirmation".visible = false
	pass # Replace with function body.


