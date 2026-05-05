extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Close_button_up():
	self.visible = false
	if get_tree().paused:
		get_tree().paused = false
	pass # Replace with function body.


func _on_Delete_Player_Saved_File_button_up():
	$"Delete Confirm Popup".visible = true
	pass # Replace with function body.
