extends TextureRect

export(String) var LogicGate = ""
export(Vector2) var drag_offset = Vector2(-32, -100)
export(float, 0, 1.0) var drag_opacity = 0.7

func _ready():
	updateText()

func updateText():
	if has_node("RichTextLabel"):
		$RichTextLabel.text = str(LogicGate)

func get_drag_data(_position):
	# Include 'source_node': self so the target knows who sent the data
	var data = {
		"texture": texture,
		"gate_name": LogicGate,
		"source_node": self 
	}
	
	var container = Control.new()
	var drag_preview = TextureRect.new()
	drag_preview.texture = texture
	drag_preview.expand = true
	drag_preview.rect_size = Vector2(64, 64)
	drag_preview.modulate = Color(1, 1, 1, drag_opacity) 
	drag_preview.rect_position = drag_offset
	
	container.add_child(drag_preview)
	set_drag_preview(container)
	
	return data

func can_drop_data(_position, data):
	# Check if the dictionary has our required keys
	return typeof(data) == TYPE_DICTIONARY and data.has("source_node")

func drop_data(_position, data):
	# 1. Get a reference to the node we dragged FROM
	var source_node = data["source_node"]
	
	# 2. Give the Source node THIS node's current data (The Swap)
	source_node.texture = self.texture
	source_node.LogicGate = self.LogicGate
	source_node.updateText() # Make sure the source's label updates too
	
	# 3. Give THIS node the data from the Source
	self.texture = data["texture"]
	self.LogicGate = data["gate_name"]
	self.updateText()
