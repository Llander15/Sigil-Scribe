extends KinematicBody2D

onready var run_sfx = $"Run SFX"
onready var jump_sfx = $"Jump SFX"

# Signals
signal interact_pressed  

# Constants
const UP = Vector2(0, -1)
const GRAVITY = 20 * 60
const SPEED = 200
const JUMP_HEIGHT = -480
const RUN_SFX_DELAY = 0.3
const FALL_GRACE_PERIOD = 0.3 
const COYOTE_TIME = 0.15 # Time in seconds player can still jump after leaving floor

# Variables
var motion = Vector2()
var snap_vector = Vector2.DOWN * 8
var run_timer = 0.0
var fall_grace_timer = 0.0
var coyote_timer = 0.0 # Tracks the "air time" for jumping

func _ready():
	randomize()
	
	# Safe button signal binding
	var interact_btn_path = "Control/TouchScreen/ControlButtons/Interact"
	if has_node(interact_btn_path):
		var interact_btn = get_node(interact_btn_path)
		interact_btn.visible = false
		if not interact_btn.is_connected("released", self, "_on_Interact_pressed"):
			interact_btn.connect("released", self, "_on_Interact_pressed")
	
	# Update player position safely using Data helper
	var saved_pos = Data.get_player_position()
	if saved_pos != Vector2.ZERO:
		self.global_position = saved_pos

func _on_Interact_pressed():
	if is_on_floor():
		emit_signal("interact_pressed")

func _physics_process(delta):
	motion.y += GRAVITY * delta
	
	# Horizontal Movement
	if Input.is_action_pressed("ui_right"):
		motion.x = SPEED
		$Sprite.flip_h = false
		$Sprite.play("run")
		
	elif Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
		$Sprite.flip_h = true
		$Sprite.play("run")
		
	else:
		motion.x = 0
		$Sprite.play("idle")
		
	# --- SFX & Coyote Timer Logic ---
	if is_on_floor():
		coyote_timer = COYOTE_TIME # Reset coyote timer while on floor
		fall_grace_timer = 0.0
		run_timer += delta 
		if abs(motion.x) > 0 and run_timer >= RUN_SFX_DELAY:
			play_running_sfx()
		elif motion.x == 0:
			run_sfx.stop()
	else:
		coyote_timer -= delta # Count down when in the air
		
		# Audio Grace Logic
		if run_sfx.playing:
			fall_grace_timer += delta
			if fall_grace_timer >= FALL_GRACE_PERIOD:
				run_sfx.stop()
				run_timer = 0.0

	# --- Jump Logic with Coyote Time ---
	if Input.is_action_just_pressed("ui_up") and coyote_timer > 0:
		motion.y = JUMP_HEIGHT
		snap_vector = Vector2.ZERO 
		coyote_timer = 0 # Prevent double jumping in mid-air
		run_sfx.stop()
		
		jump_sfx.pitch_scale = rand_range(0.8, 1.1)
		jump_sfx.play()
	
	# Visuals & Snap updates
	if not is_on_floor():
		$Sprite.play("jump")
		if motion.y > 0:
			snap_vector = Vector2.DOWN * 8
	else:
		if not Input.is_action_just_pressed("ui_up"):
			snap_vector = Vector2.DOWN * 8

	motion = move_and_slide_with_snap(motion, snap_vector, UP, true)

func play_running_sfx():
	if not run_sfx.playing:
		run_sfx.pitch_scale = rand_range(0.8, 1.2)
		run_sfx.play()
