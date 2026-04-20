extends Area2D
 
func _on_Area2D_body_entered(body):
	$"../Control/TouchScreen/Interact".visible = true
	#set what the interact will do here
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	$"../Control/TouchScreen/Interact".visible = false
	pass # Replace with function body.
