extends TextureRect

var puzzle_start = false

# Set this in the Inspector. True = Output must be ON to win.
export(bool) var required_state = true 
var solved = false

func _ready():
	# Keeps the target indicator cleanly set without inheriting parent tints
	if required_state == true:
		$"RS indicator".modulate = Color(0.0, 1.0, 0.0) # Green
	else:
		$"RS indicator".modulate = Color(1.0, 0.4, 0.4) # Light Red

func _on_signal_received(incoming_state):
	# Logic to determine which of the 4 states we are in
	if incoming_state == true:
		if required_state == true:
			# CORRECT POSITIVE (Light Green)
			apply_state_visuals(Color(0.0, 1.0, 0.0), true)
		else:
			# WRONG POSITIVE (Dark Green)
			apply_state_visuals(Color(0.0, 0.6, 0.0), false)
	elif incoming_state == false:
		if required_state == false:
			# CORRECT NEGATIVE (Light Red)
			apply_state_visuals(Color(1.0, 0.4, 0.4), true)
		else:
			# WRONG NEGATIVE (Dark Red)
			apply_state_visuals(Color(0.6, 0.0, 0.0), false)
	else:
		# Handles null / disconnected state safely
		apply_state_visuals(Color(0.5, 0.5, 0.5), false)
		

func apply_state_visuals(state_color, is_correct):
	# CHANGED: Using self_modulate so children stay their original colors
	self.self_modulate = state_color
	solved = is_correct
	
	if is_correct:
		print("Logic Check: SUCCESS")
		if has_node("VictoryParticles"):
			$VictoryParticles.emitting = true
	else:
		if has_node("VictoryParticles"):
			$VictoryParticles.emitting = false

func set_null_state():
	# Call this if the puzzle hasn't been touched yet
	solved = false
	self.self_modulate = Color(0.5, 0.5, 0.5)

func reset_state():
	# Return to normal (White / Un-tinted)
	solved = false
	self.self_modulate = Color(1, 1, 1)
	if has_node("VictoryParticles"):
		$VictoryParticles.emitting = false
