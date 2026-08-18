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
	update_popup() # For Hint

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
	current_output = null # back to default
	
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
			
	# Only emit if the result actually changed to save performance
	emit_signal("signal_updated", current_output)

# --- Your Drag and Drop Logic ---
var drag_icon_texture = preload("res://Assets/hand.png")

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
		
		#Drag Icon
		var drag_icon = TextureRect.new()
		drag_icon.texture = drag_icon_texture
		drag_icon.expand = true
		drag_icon.rect_size = Vector2(32, 32)
		drag_icon.rect_position = Vector2(-16, -16) # Centered on the finger/cursor
		
		# 3. Position the visual RELATIVE to the pivot
		drag_preview.rect_position = Vector2(-32, -100) 
		
		# 4. Put the visual inside the pivot and show the pivot
		pivot.add_child(drag_preview)
		pivot.add_child(drag_icon) #drag
		set_drag_preview(pivot)
		
		# Make sure popup text matches the dragged gate before starting timer
		update_popup(LogicGate)
		$CanvasLayer/Timer.start()
		
		return data

func _process(_delta):
	# Only run if the timer is currently counting down
	if not $CanvasLayer/Timer.is_stopped():
		var elapsed_time = $CanvasLayer/Timer.wait_time - $CanvasLayer/Timer.time_left
		
		# Show the canvas layer once 2 seconds have passed
		if elapsed_time >= 2.0:
			$CanvasLayer.visible = true

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		$CanvasLayer/Timer.start(0) 
		$CanvasLayer/Timer.stop()
		
		$CanvasLayer.visible = false

func can_drop_data(_position, data):
	return typeof(data) == TYPE_DICTIONARY and data.has("source_node")

func drop_data(_position, data):
	var source_node = data["source_node"]
	
	# Swap textures
	source_node.texture = self.texture
	self.texture = data["texture"]
	
	# Swap LogicGate variables
	source_node.LogicGate = self.LogicGate
	self.LogicGate = data["gate_name"]
	
	# Update visual text, logic evaluation, sprites, and popup hints for both nodes
	source_node.updateText()
	source_node.updateSprite()
	source_node.update_popup()
	
	self.updateText()
	self.updateSprite()
	self.update_popup()

# HINT DATA
var logic_gates_hint = [
	{
		"name": "AND",
		"text": "AND GATE\nOutputs [color=#40ff40]1[/color] ONLY if ALL inputs are [color=#40ff40]1[/color].\n\n A | B | OUT\n---+---+----\n [color=#ff4040]0[/color] | [color=#ff4040]0[/color] |  [color=#ff4040]0[/color]\n [color=#ff4040]0[/color] | [color=#40ff40]1[/color] |  [color=#ff4040]0[/color]\n [color=#40ff40]1[/color] | [color=#ff4040]0[/color] |  [color=#ff4040]0[/color]\n [color=#40ff40]1[/color] | [color=#40ff40]1[/color] |  [color=#40ff40]1[/color]"
	},
	{
		"name": "OR",
		"text": "OR GATE\nOutputs [color=#40ff40]1[/color] if AT LEAST ONE input is [color=#40ff40]1[/color].\n\n A | B | OUT\n---+---+----\n [color=#ff4040]0[/color] | [color=#ff4040]0[/color] |  [color=#ff4040]0[/color]\n [color=#ff4040]0[/color] | [color=#40ff40]1[/color] |  [color=#40ff40]1[/color]\n [color=#40ff40]1[/color] | [color=#ff4040]0[/color] |  [color=#40ff40]1[/color]\n [color=#40ff40]1[/color] | [color=#40ff40]1[/color] |  [color=#40ff40]1[/color]"
	},
	{
		"name": "NAND",
		"text": "NAND GATE\nOpposite of AND. Outputs [color=#ff4040]0[/color] ONLY if ALL inputs are [color=#40ff40]1[/color].\n\n A | B | OUT\n---+---+----\n [color=#ff4040]0[/color] | [color=#ff4040]0[/color] |  [color=#40ff40]1[/color]\n [color=#ff4040]0[/color] | [color=#40ff40]1[/color] |  [color=#40ff40]1[/color]\n [color=#40ff40]1[/color] | [color=#ff4040]0[/color] |  [color=#40ff40]1[/color]\n [color=#40ff40]1[/color] | [color=#40ff40]1[/color] |  [color=#ff4040]0[/color]"
	},
	{
		"name": "NOR",
		"text": "NOR GATE\nOpposite of OR. Outputs [color=#40ff40]1[/color] ONLY if ALL inputs are [color=#ff4040]0[/color].\n\n A | B | OUT\n---+---+----\n [color=#ff4040]0[/color] | [color=#ff4040]0[/color] |  [color=#40ff40]1[/color]\n [color=#ff4040]0[/color] | [color=#40ff40]1[/color] |  [color=#ff4040]0[/color]\n [color=#40ff40]1[/color] | [color=#ff4040]0[/color] |  [color=#ff4040]0[/color]\n [color=#40ff40]1[/color] | [color=#40ff40]1[/color] |  [color=#ff4040]0[/color]"
	},
	{
		"name": "XOR",
		"text": "XOR GATE\nOutputs [color=#40ff40]1[/color] if inputs are DIFFERENT.\n\n A | B | OUT\n---+---+----\n [color=#ff4040]0[/color] | [color=#ff4040]0[/color] |  [color=#ff4040]0[/color]\n [color=#ff4040]0[/color] | [color=#40ff40]1[/color] |  [color=#40ff40]1[/color]\n [color=#40ff40]1[/color] | [color=#ff4040]0[/color] |  [color=#40ff40]1[/color]\n [color=#40ff40]1[/color] | [color=#40ff40]1[/color] |  [color=#ff4040]0[/color]"
	},
	{
		"name": "XNOR",
		"text": "XNOR GATE\nOutputs [color=#40ff40]1[/color] if inputs are the SAME.\n\n A | B | OUT\n---+---+----\n [color=#ff4040]0[/color] | [color=#ff4040]0[/color] |  [color=#40ff40]1[/color]\n [color=#ff4040]0[/color] | [color=#40ff40]1[/color] |  [color=#ff4040]0[/color]\n [color=#40ff40]1[/color] | [color=#ff4040]0[/color] |  [color=#ff4040]0[/color]\n [color=#40ff40]1[/color] | [color=#40ff40]1[/color] |  [color=#40ff40]1[/color]"
	},
	{
		"name": "NOT",
		"text": "NOT GATE\nInverts the single input.\n\n A | OUT\n---+----\n [color=#ff4040]0[/color] |  [color=#40ff40]1[/color]\n [color=#40ff40]1[/color] |  [color=#ff4040]0[/color]"
	}
]

func update_popup(gate_name: String = LogicGate):
	if has_node("CanvasLayer/Panel/hint"):
		for gate in logic_gates_hint:
			if gate["name"] == gate_name.to_upper():
				$CanvasLayer/Panel/hint.bbcode_text = gate["text"]
				break


