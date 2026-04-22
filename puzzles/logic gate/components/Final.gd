extends TextureRect

# Set this in the Inspector. True = Output must be ON to win.
export(bool) var required_state = true 

func _on_signal_received(incoming_state):
	if incoming_state == required_state:
		level_cleared()
	else:
		reset_state()

func level_cleared():
	# Visual feedback: Make the huge box glow bright violet
	self.modulate = Color(2.0, 1.5, 2.5) 
	print("Logic Check: SUCCESS")
	# You can trigger a victory popup or particles here
	if has_node("VictoryParticles"):
		$VictoryParticles.emitting = true

func reset_state():
	# Return to normal if the logic is incorrect
	self.modulate = Color(1, 1, 1)
	if has_node("VictoryParticles"):
		$VictoryParticles.emitting = false
