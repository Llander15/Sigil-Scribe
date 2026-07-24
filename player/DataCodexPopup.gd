extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	$SQL.visible = false
	$DL.visible = false
	pass # Replace with function body.

func _on_close_pressed():
	self.visible = false
	if get_tree().paused:
		get_tree().paused = false
	pass # Replace with function body.


func _on_DLBtn_pressed():
	$Main.visible = false
	$DL.visible = true
	pass # Replace with function body.


func _on_SQLBtn_pressed():
	$Main.visible = false
	$SQL.visible = true
	pass # Replace with function body.


func _on_sqlclose_pressed():
	$Main.visible = true
	$SQL.visible = false
	pass # Replace with function body.

func _on_dlclose_pressed():
	$Main.visible = true
	$DL.visible = false
	pass # Replace with function body.




