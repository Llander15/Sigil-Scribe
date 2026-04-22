extends Control

# Colors for your theme
export(Color) var color_on = Color("8a2be2") # Violet (Active)
export(Color) var color_off = Color("444444") # Dark Grey (Inactive)

onready var line = $Line2D

func _ready():
	# Set initial visual state to 'off'
	update_visuals(false)

# This is the function called by the Signal Handshake in the Level script
func _on_signal_received(state):
	update_visuals(state)

func update_visuals(state):
	if line:
		if state:
			line.default_color = color_on
			# Optional: Add a subtle glow/width increase when active
			line.width = 4.0
		else:
			line.default_color = color_off
			line.width = 3.0
