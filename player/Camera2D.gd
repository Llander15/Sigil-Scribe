extends Camera2D

# Adjust these to fit your 640x360 resolution
export var look_ahead_distance = 100.0
export var shift_duration = 1 # How many seconds the transition takes

onready var player = get_parent() # Assumes Camera is a child of the Player

func _process(_delta):
	var move_dir = Input.get_axis("ui_left", "ui_right")
	
	if move_dir != 0:
		# Player is moving - Shift camera in front
		var target_offset = move_dir * look_ahead_distance
		shift_camera(target_offset)
	else:
		# Player is idle - Reset to center
		shift_camera(0)

func shift_camera(target_x):
	# Create a tween (Godot 3.5+)
	var tween = create_tween()
	
	# Transition the 'offset:x' to the target over 'shift_duration'
	# Use TRANS_SINE or TRANS_QUAD for a smooth 'organic' feel
	tween.tween_property(self, "offset:x", target_x, shift_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
