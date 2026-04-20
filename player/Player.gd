extends KinematicBody2D

#signals
signal interact_pressed  # signal for pressing interact button

func _ready():
	# interact button setup
	$Control/TouchScreen/Interact.visible = false
	var interact_btn = get_node("Control/TouchScreen/Interact")
	interact_btn.connect("released", self, "_on_Interact_pressed")
	pass

# runs this function when interact button is pressed
func _on_Interact_pressed():
	emit_signal("interact_pressed")
	print("Interact Btn tapped -> Signal emitted!")
	pass

const UP = Vector2(0, -1)
const GRAVITY = 20 * 60
const SPEED = 200
const JUMP_HEIGHT = -550

var motion = Vector2()

func _physics_process(delta):
	
	motion.y += GRAVITY * delta
	
	if Input.is_action_pressed("ui_right"):
		motion.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
	else:
		motion.x = 0

	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
	
	motion = move_and_slide(motion, UP)
	

