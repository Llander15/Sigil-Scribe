#extends Camera2D
#
## Adjust these to fit your 640x360 resolution
#export var look_ahead_distance = 100.0
#export var shift_duration = 4 # How many seconds the transition takes
#
#onready var player = get_parent() # Assumes Camera is a child of the Player
#
#func _process(_delta):
#	var move_dir = Input.get_axis("ui_left", "ui_right")
#
#	if move_dir != 0:
#		# Player is moving - Shift camera in front
#		var target_offset = move_dir * look_ahead_distance
#		shift_camera(target_offset)
#	else:
#		# Player is idle - Reset to center
#		shift_camera(0)
#
#func shift_camera(target_x):
#	# Create a tween (Godot 3.5+)
#	var tween = create_tween()
#
#	# Transition the 'offset:x' to the target over 'shift_duration'
#	# Use TRANS_SINE or TRANS_QUAD for a smooth 'organic' feel
#	tween.tween_property(self, "offset:x", target_x, shift_duration)\
#		.set_trans(Tween.TRANS_SINE)\
#		.set_ease(Tween.EASE_OUT)

extends Camera2D

# Adjust these to fit your 640x360 resolution
export var look_ahead_distance = 100.0
export var shift_duration = 1.5 # Tip: 4 seconds is very slow! 1.5s feels much snappier.

onready var player = get_parent() # Assumes Camera is a child of the Player

var last_dir = 0.0 # Tracks the player's previous direction to prevent spamming Tweens
var camera_tween: SceneTreeTween # Holds our active tween safely

func _ready():
	# 1. Kill smoothing instantly on launch so it doesn't drag from (0,0)
	smoothing_enabled = false
	force_update_scroll()
	
	# 2. Wait exactly one frame for the position to snap
	yield(get_tree(), "idle_frame")
	
	# 3. Re-enable camera smoothing for regular gameplay
	smoothing_enabled = true


func _process(_delta):
	var move_dir = Input.get_axis("ui_left", "ui_right")
	
	# ONLY act if the input direction has actually changed!
	if move_dir != last_dir:
		last_dir = move_dir # Update our tracked direction
		
		if move_dir != 0:
			# Player started moving - Shift camera in front
			var target_offset = move_dir * look_ahead_distance
			shift_camera(target_offset)
		else:
			# Player stopped moving - Reset to center
			shift_camera(0)


func shift_camera(target_x):
	# 1. Safely kill the previous tween if it's still running
	if camera_tween and camera_tween.is_valid():
		camera_tween.kill()
		
	# 2. Create the new tween
	camera_tween = create_tween()
	
	# 3. Smoothly slide the offset over time
	camera_tween.tween_property(self, "offset:x", target_x, shift_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
