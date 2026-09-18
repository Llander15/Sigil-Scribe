extends TextureRect

# Signal emitted AFTER delay finishes and solution state is evaluated
signal evaluation_completed(is_correct)

var puzzle_start = false

# Set this in the Inspector. True = Output must be ON to win.
export(bool) var required_state = true 
export var update_on_confirm: bool = false

# Time to wait (in seconds) before starting the transformation
export(float) var delay: float = 0.0

# How long (in seconds) the color transition takes
export(float) var transition_time: float = 0.5

var solved = false
var recieved_state = null

# Prevents older queued delays from running if a new signal arrives
var current_update_id: int = 0

onready var tween = $Tween if has_node("Tween") else null

func _ready():
	# Keeps the target indicator cleanly set without inheriting parent tints
	if bool(required_state) == true:
		$"RS indicator".modulate = Color(0.0, 1.0, 0.0) # Green
	else:
		$"RS indicator".modulate = Color(1.0, 0.4, 0.4) # Light Red

func _on_signal_received(incoming_state):
	recieved_state = incoming_state
	
	if not update_on_confirm:
		apply_state_with_delay(incoming_state)

# Call this function when the player clicks the Confirm / Check button
func confirm_state():
	apply_state_with_delay(recieved_state)

func apply_state_with_delay(state):
	if delay > 0.0:
		current_update_id += 1
		var update_id = current_update_id
		
		yield(get_tree().create_timer(delay), "timeout")
		
		# Cancel execution if a newer signal was sent during the delay
		if update_id != current_update_id:
			return

	process_state_logic(state)

# Shared logic for evaluating the incoming state against required_state
func process_state_logic(incoming_state):
	if incoming_state == null:
		apply_state_visuals(Color(0.5, 0.5, 0.5), false)
		emit_signal("evaluation_completed", false)
		return

	# Explicitly cast to boolean to avoid int/bool type comparison bugs
	var state_bool: bool = bool(incoming_state)
	var required_bool: bool = bool(required_state)

	if state_bool == required_bool:
		if required_bool:
			# CORRECT POSITIVE (Light Green)
			apply_state_visuals(Color(0.0, 1.0, 0.0), true)
		else:
			# CORRECT NEGATIVE (Light Red)
			apply_state_visuals(Color(1.0, 0.4, 0.4), true)
	else:
		if state_bool:
			# WRONG POSITIVE (Dark Green)
			apply_state_visuals(Color(0.0, 0.6, 0.0), false)
		else:
			# WRONG NEGATIVE (Dark Red)
			apply_state_visuals(Color(0.6, 0.0, 0.0), false)

	emit_signal("evaluation_completed", solved)

func apply_state_visuals(target_color: Color, is_correct: bool):
	solved = is_correct

	# Handle smooth color transformation using $Tween
	if tween and transition_time > 0.0:
		tween.stop(self, "self_modulate")
		tween.interpolate_property(
			self, "self_modulate",
			self.self_modulate, target_color,
			transition_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT
		)
		tween.start()
	else:
		self.self_modulate = target_color
	
	if has_node("VictoryParticles"):
		$VictoryParticles.emitting = is_correct

func set_null_state():
	solved = false
	recieved_state = null
	apply_state_visuals(Color(0.5, 0.5, 0.5), false)

func reset_state():
	solved = false
	recieved_state = null
	apply_state_visuals(Color(1, 1, 1), false)
