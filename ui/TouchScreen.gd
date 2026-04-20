extends CanvasLayer

# 1. YOU MUST ADD THIS LINE AT THE VERY TOP
signal interact_pressed 

func _ready():
	$Interact.visible = false

func _on_Interact_pressed():
	# 2. This now "shouts" to any script listening
	emit_signal("interact_pressed")
	print("UI Script: Signal sent!") # Add this to confirm the button works
