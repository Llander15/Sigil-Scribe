extends Control

# Colors for your theme
export(Color) var color_on = Color("32ff32") 
export(Color) var color_off = Color("ff0000") 
export(Color) var color_null = Color("707070")

export var update_on_confirm: bool = false

# Delay in seconds before the visual transformation starts
export(float) var delay: float = 0.0

# Duration in seconds of the color & width transition
export(float) var transition_time: float = 0.5

onready var line = $Line2D
onready var tween = $Tween if has_node("Tween") else null

var recieved_state

# Tracks active delay operations to prevent race conditions
var current_update_id: int = 0

func _ready():
	# Ensure a Tween node exists for smooth animations
	if not tween:
		tween = Tween.new()
		add_child(tween)
		
	# Set initial visual state immediately without delay or transition
	update_visuals_instant(null)

# Signal callback from Level script
func _on_signal_received(state):
	recieved_state = state
	if not update_on_confirm:
		apply_state_with_delay(state)

# Call this if update_on_confirm is true and player clicks Confirm
func confirm_state():
	apply_state_with_delay(recieved_state)

func apply_state_with_delay(state):
	if delay > 0.0:
		current_update_id += 1
		var update_id = current_update_id
		
		yield(get_tree().create_timer(delay), "timeout")
		
		if update_id != current_update_id:
			return

	animate_visuals(state)

# Smoothly transitions color and width using Tween
func animate_visuals(state):
	if not line:
		return

	var target_color: Color
	var target_width: float

	if state == true:
		target_color = color_on
		target_width = 4.0
	elif state == false:
		target_color = color_off
		target_width = 3.0
	else:
		target_color = color_null
		target_width = 2.5

	# Instant update if transition_time is 0
	if transition_time <= 0.0:
		line.default_color = target_color
		line.width = target_width
		return

	# Stop previous animations before starting new ones
	tween.stop_all()

	# Animate color
	tween.interpolate_property(
		line, "default_color",
		line.default_color, target_color,
		transition_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)

	# Animate width
	tween.interpolate_property(
		line, "width",
		line.width, target_width,
		transition_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)

	tween.start()

# Sets initial visuals immediately (used in _ready)
func update_visuals_instant(state):
	if line:
		if state == true:
			line.default_color = color_on
			line.width = 4.0
		elif state == false:
			line.default_color = color_off
			line.width = 3.0
		else:
			line.default_color = color_null
			line.width = 2.5
