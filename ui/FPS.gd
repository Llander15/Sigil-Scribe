extends Label

func _process(_delta):
	# Built-in function to get the current FPS
	var fps = Engine.get_frames_per_second()
	
	# Update the text of the label
	text = "FPS: " + str(fps)
