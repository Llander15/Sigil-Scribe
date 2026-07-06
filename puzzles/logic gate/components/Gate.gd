extends TextureRect

# --- Signals & Variables ---
signal signal_updated(state)

export(String) var LogicGate = ""
export var SingleInput: bool = false
export(Vector2) var drag_offset = Vector2(-32, -100)
export(float, 0, 1.0) var drag_opacity = 0.7

var input_a
var input_b 
var current_output 
var draggable = false

func _ready():
	updateText()
	updateSprite()
	

func updateText():
	if has_node("RichTextLabel"):
		$RichTextLabel.text = str(LogicGate)
	# CRITICAL: Every time the gate changes (swaps), recalculate the math!
	if LogicGate:
		draggable = true
	else:
		draggable = false
	evaluate_logic()

func updateSprite():
	match LogicGate.to_upper():
		"AND":
			self.texture = load("res://Assets/logicGates/and.png") 
		"OR":
			self.texture = load("res://Assets/logicGates/or.png")
		"NAND":
			self.texture = load("res://Assets/logicGates/nand.png")
		"NOR":
			self.texture = load("res://Assets/logicGates/nor.png")
		"XOR":
			self.texture = load("res://Assets/logicGates/xor.png")
		"XNOR":
			self.texture = load("res://Assets/logicGates/xnor.png")
		"NOT":
			self.texture = load("res://Assets/logicGates/not.png")
		_:
			self.texture = load("res://Assets/logicGates/blank.png")

# --- Signal Catching ---
func _on_input_a_received(state):
	input_a = state
	evaluate_logic()

func _on_input_b_received(state):
	input_b = state
	evaluate_logic()

# --- The Logic Brain ---
func evaluate_logic():
	current_output = null #back to default, the match default doesnt work for sum reas
	
	# Logic math based on the string name
	match LogicGate.to_upper():
		"AND":
			if input_a != null and input_b != null and not SingleInput:
				current_output = input_a and input_b
		"OR":
			if input_a != null and input_b != null and not SingleInput:
				current_output = input_a or input_b
		"NAND":
			if input_a != null and input_b != null and not SingleInput:
				current_output = not (input_a and input_b)
		"NOR":
			if input_a != null and input_b != null and not SingleInput:
				current_output = not (input_a or input_b)
		"XOR":
			if input_a != null and input_b != null and not SingleInput:
				current_output = input_a != input_b
		"XNOR":
			if input_a != null and input_b != null and not SingleInput:
				current_output = input_a == input_b
		"NOT":
			if SingleInput:
				current_output = not input_a
			else:
				current_output = null
		_:
			current_output = null
	
#	if input_a == null:
#		current_output = null
	
	
		
	
	# Only emit if the result actually changed to save performance
	emit_signal("signal_updated", current_output)

# --- Your Drag and Drop Logic ---
func get_drag_data(_position):
	if draggable:
		var data = {
			"texture": texture,
			"gate_name": LogicGate,
			"source_node": self 
		}

		# 1. Create a "Pivot" node that stays at your finger
		var pivot = Control.new()
		
		# 2. Create the actual Gate visual
		var drag_preview = TextureRect.new()
		drag_preview.texture = texture
		drag_preview.expand = true
		drag_preview.rect_size = Vector2(64, 64)
		drag_preview.modulate = Color(1, 1, 1, drag_opacity) 
		
		# 3. Position the visual RELATIVE to the pivot
		drag_preview.rect_position = Vector2(-32, -100) 
		
		# 4. Put the visual inside the pivot and show the pivot
		pivot.add_child(drag_preview)
		set_drag_preview(pivot)
		
		return data



func can_drop_data(_position, data):
	return typeof(data) == TYPE_DICTIONARY and data.has("source_node")

func drop_data(_position, data):
	var source_node = data["source_node"]
	
	# Swap data
	source_node.texture = self.texture
	source_node.LogicGate = self.LogicGate
	source_node.updateText()
	
	self.texture = data["texture"]
	self.LogicGate = data["gate_name"]
	self.updateText()
