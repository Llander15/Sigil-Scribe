extends Area2D

export var npc_name : String = "Senior Scribe"
export var important : bool = false
# Export an array of mission numbers where this NPC is priority (e.g. [0, 2])
export(Array, int) var target_mission_numbers = [0, 2]

# Dialogue arrays
export(Array, String, MULTILINE) var dialogue_lines = [
	"Welcome, %s. Use the Logic Gauntlet to fix this circuit.",
	"Be careful—the power grid here is unstable.",
	"Find the missing gate and restore the flow!"
]

export(Array, String, MULTILINE) var dialogue_lines2 = [
	"Welcome back, %s! The Data Codex shows your progress.",
	"The core gate is active. Proceed to the next section."
]

var is_player_nearby = false
var target_player = null
var is_dialogue_active = false # Tracks if dialogue is currently running

# Tracks active dialogue state
var current_dialogue_array : Array = []
var current_line_index : int = 0

onready var dialogue_ui = $CanvasLayer/NinePatchRect
onready var label = $CanvasLayer/NinePatchRect/Label
onready var next_indicator = $CanvasLayer/NinePatchRect/NextIndicator

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	# Connect to the global signal safely
	if Data.has_signal("mission_updated"):
		if not Data.is_connected("mission_updated", self, "_on_mission_updated"):
			Data.connect("mission_updated", self, "_on_mission_updated")
	
	check_mission_importance()
	
	dialogue_ui.hide()
	if next_indicator:
		next_indicator.hide()

func _on_mission_updated(new_mission: int):
	print("NPC received mission update signal! New mission: ", new_mission)
	check_mission_importance()

func check_mission_importance():
	# Ensure current_mission is explicitly converted to int for comparison
	var current_mission = int(Data.save_data.get("mission_number", -1))
	
	# Checks if current_mission matches ANY integer in target_mission_numbers
	if current_mission in target_mission_numbers:
		important = true
		_active_icon()
	else:
		important = false
		_deactivate_icon()

func _on_NPC_body_entered(body):
	if body.name == "Player":
		target_player = body
		is_player_nearby = true
		
		var interact_node = body.get_node_or_null("Control/TouchScreen/ControlButtons/Interact")
		if interact_node:
			interact_node.visible = true
			
		if not body.is_connected("interact_pressed", self, "_on_player_interacted"):
			body.connect("interact_pressed", self, "_on_player_interacted")

func _on_NPC_body_exited(body):
	if body.name == "Player":
		is_player_nearby = false
		
		var interact_node = body.get_node_or_null("Control/TouchScreen/ControlButtons/Interact")
		if interact_node:
			interact_node.visible = false
			
		if body.is_connected("interact_pressed", self, "_on_player_interacted"):
			body.disconnect("interact_pressed", self, "_on_player_interacted")
			
		# Only close dialogue if it's currently active (prevents accidental trigger on walk-by)
		if is_dialogue_active:
			close_dialogue()
		
		target_player = null

func _on_player_interacted():
	if not dialogue_ui.visible:
		start_dialogue()

func start_dialogue():
	# Choose dialogue lines based on achievement data
	var achievements = Data.save_data.get("ach", [])
	if "Data Codex" in achievements:
		current_dialogue_array = dialogue_lines2
	else:
		current_dialogue_array = dialogue_lines

	if current_dialogue_array.empty():
		return

	is_dialogue_active = true
	get_tree().paused = true

	if target_player and is_instance_valid(target_player):
		target_player.pause_mode = Node.PAUSE_MODE_PROCESS

	set_player_ui_visible(false)

	current_line_index = 0
	set_current_line_text()
	dialogue_ui.show()
	update_indicator()

func advance_dialogue():
	current_line_index += 1
	if current_line_index < current_dialogue_array.size():
		set_current_line_text()
		update_indicator()
	else:
		close_dialogue()

func set_current_line_text():
	var raw_text = current_dialogue_array[current_line_index]
	var player_name = Data.save_data.get("player_name", "Novice")
	
	if "%s" in raw_text:
		label.text = raw_text % player_name
	else:
		label.text = raw_text

func update_indicator():
	if next_indicator:
		next_indicator.visible = (current_line_index < current_dialogue_array.size() - 1)

func close_dialogue():
	get_tree().paused = false
	
	if target_player and is_instance_valid(target_player):
		target_player.pause_mode = Node.PAUSE_MODE_INHERIT

	dialogue_ui.hide()
	if next_indicator:
		next_indicator.hide()

	set_player_ui_visible(true)
	
	# Only advance mission if dialogue was actually finished naturally
	if is_dialogue_active and current_line_index >= current_dialogue_array.size() - 1:
		var current_mission = int(Data.save_data.get("mission_number", -1))
		if important:
			important = false
			_deactivate_icon()
			if current_mission == 0 or current_mission == 2:
				if Data.has_method("advance_mission"):
					Data.advance_mission()

	is_dialogue_active = false
	current_line_index = 0

func set_player_ui_visible(is_visible: bool):
	if target_player and is_instance_valid(target_player):
		var touch_screen = target_player.get_node_or_null("Control/TouchScreen")
		if touch_screen:
			touch_screen.visible = is_visible

func _on_NinePatchRect_gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		get_tree().set_input_as_handled()
		advance_dialogue()

func _active_icon():
	if has_node("Priority"):
		$Priority.visible = true

func _deactivate_icon():
	if has_node("Priority"):
		$Priority.visible = false
