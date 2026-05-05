extends TextureRect

var puzzle_start = false

# Set this in the Inspector. True = Output must be ON to win.
export(bool) var required_state = true 
var solved = false

func _on_signal_received(incoming_state):
	if incoming_state == required_state:
		level_cleared()
	else:
		reset_state()

func level_cleared():
	# Visual feedback: Make the huge box glow bright violet
	solved = true
	self.modulate = Color(2.0, 1.5, 2.5) 
	print("Logic Check: SUCCESS")
	# You can trigger a victory popup or particles here
	if has_node("VictoryParticles"):
		$VictoryParticles.emitting = true
	
#	if puzzle_start:
#		if	$"../../../../platform/AnimationPlayer".current_animation == "RESET":
#			$"../../../../platform/AnimationPlayer".play("moving platform")
#		if $"../../../../Area2D/CollisionShape2D".disabled == false:
#			$"../../../../Area2D/CollisionShape2D".disabled = true
#		if $"../../../../Area2D/before".visible:
#			$"../../../../Area2D/before".visible = false
#		if $"../../../../Area2D/after".visible == false:
#			$"../../../../Area2D/after".visible = true
	
	

func reset_state():
	# Return to normal if the logic is incorrect
	solved = false
	self.modulate = Color(1, 1, 1)
	if has_node("VictoryParticles"):
		$VictoryParticles.emitting = false
