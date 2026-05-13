#extends TextureRect
#
#var puzzle_start = false
#
## Set this in the Inspector. True = Output must be ON to win.
#export(bool) var required_state = true 
#var solved = false
#
#func _on_signal_received(incoming_state):
#	if incoming_state == required_state:
#		level_cleared()
#	else:
#		reset_state()
#
#func level_cleared():
#	# Visual feedback: Make the huge box glow bright violet
#	solved = true
#	self.modulate = Color(2.0, 1.5, 2.5) 
#	print("Logic Check: SUCCESS")
#	# You can trigger a victory popup or particles here
#	if has_node("VictoryParticles"):
#		$VictoryParticles.emitting = true
#
##	if puzzle_start:
##		if	$"../../../../platform/AnimationPlayer".current_animation == "RESET":
##			$"../../../../platform/AnimationPlayer".play("moving platform")
##		if $"../../../../Area2D/CollisionShape2D".disabled == false:
##			$"../../../../Area2D/CollisionShape2D".disabled = true
##		if $"../../../../Area2D/before".visible:
##			$"../../../../Area2D/before".visible = false
##		if $"../../../../Area2D/after".visible == false:
##			$"../../../../Area2D/after".visible = true
#
#
#
#func reset_state():
#	# Return to normal if the logic is incorrect
#	solved = false
#	self.modulate = Color(1, 1, 1)
#	if has_node("VictoryParticles"):
#		$VictoryParticles.emitting = false

extends TextureRect

var puzzle_start = false

# Set this in the Inspector. True = Output must be ON to win.
export(bool) var required_state = true 
var solved = false

func _on_signal_received(incoming_state):
	# Logic to determine which of the 4 states we are in
	if incoming_state == true:
		if required_state == true:
			# CORRECT POSITIVE (Light Green)
			apply_state_visuals(Color(1.2, 2.0, 1.2), true)
		else:
			# WRONG POSITIVE (Dark Green)
			apply_state_visuals(Color(0.0, 0.6, 0.0), false)
	elif incoming_state == false:
		if required_state == false:
			# CORRECT NEGATIVE (Light Red)
			apply_state_visuals(Color(2.0, 1.2, 1.2), true)
		else:
			# WRONG NEGATIVE (Dark Red)
			apply_state_visuals(Color(0.6, 0.0, 0.0), false)
	else:
		apply_state_visuals(Color(0.5, 0.5, 0.5), false)
		

func apply_state_visuals(state_color, is_correct):
	self.modulate = state_color
	solved = is_correct
	
	if is_correct:
		print("Logic Check: SUCCESS")
		if has_node("VictoryParticles"):
			$VictoryParticles.emitting = true
		# Trigger your level_cleared logic here if needed
	else:
		if has_node("VictoryParticles"):
			$VictoryParticles.emitting = false

func set_null_state():
	# Call this if the puzzle hasn't been touched yet
	solved = false
	self.modulate = Color(0.5, 0.5, 0.5)

func reset_state():
	# Return to normal (White)
	solved = false
	self.modulate = Color(1, 1, 1)
	if has_node("VictoryParticles"):
		$VictoryParticles.emitting = false
