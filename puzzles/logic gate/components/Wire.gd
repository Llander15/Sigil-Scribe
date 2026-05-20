extends Control

# Colors for your theme
export(Color) var color_on = Color("32ff32") 
export(Color) var color_off = Color("ff0000") 
export(Color) var color_null = Color("707070")

onready var line = $Line2D

func _ready():
	# Set initial visual state to 'off'
	update_visuals(null)

# This is the function called by the Signal Handshake in the Level script
func _on_signal_received(state):
	update_visuals(state)

func update_visuals(state):
	if line:
		if state == true:
			line.default_color = color_on
			# Optional: Add a subtle glow/width increase when active
			line.width = 4.0
		elif state == false:
			line.default_color = color_off
			line.width = 3.0
		else:
			line.default_color = color_null
			line.width = 2.5
