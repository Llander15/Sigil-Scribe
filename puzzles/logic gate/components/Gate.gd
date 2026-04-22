extends TextureRect

# --- Signals & Variables ---
signal signal_updated(state)

export(String) var LogicGate = ""
export(Vector2) var drag_offset = Vector2(-32, -100)
export(float, 0, 1.0) var drag_opacity = 0.7

var input_a = false
var input_b = false
var current_output = false

func _ready():
	updateText()

func updateText():
	if has_node("RichTextLabel"):
		$RichTextLabel.text = str(LogicGate)
	# CRITICAL: Every time the gate changes (swaps), recalculate the math!
	evaluate_logic()

# --- Signal Catching ---
func _on_input_a_received(state):
	input_a = state
	evaluate_logic()

func _on_input_b_received(state):
	input_b = state
	evaluate_logic()

# --- The Logic Brain ---
func evaluate_logic():
	var old_output = current_output
	
	# Logic math based on the string name
	match LogicGate.to_upper():
		"AND":
			current_output = input_a and input_b
		"OR":
			current_output = input_a or input_b
		"NAND":
			current_output = not (input_a and input_b)
		"NOR":
			current_output = not (input_a or input_b)
		"XOR":
			current_output = input_a != input_b
		"NOT":
			current_output = not input_a
		_:
			current_output = false
	
	# Only emit if the result actually changed to save performance
	emit_signal("signal_updated", current_output)

# --- Your Drag and Drop Logic ---
func get_drag_data(_position):
	var data = {
		"texture": texture,
		"gate_name": LogicGate,
		"source_node": self 
	}
	
	# Create the preview directly
	var drag_preview = TextureRect.new()
	drag_preview.texture = texture
	drag_preview.expand = true
	drag_preview.rect_size = Vector2(64, 64)
	drag_preview.modulate = Color(1, 1, 1, drag_opacity) 
	
	# Setting the position to half the size centers it on your touch/cursor
	drag_preview.rect_position = Vector2(-32, -32) 
	
	# Use the TextureRect directly as the preview
	set_drag_preview(drag_preview)
	
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
