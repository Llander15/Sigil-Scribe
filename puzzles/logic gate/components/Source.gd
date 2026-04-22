extends TextureRect

# The "Wi-Fi" signal that the wires and gates listen to
signal signal_updated(state)

# Configuration for the Lead Developer
export(String) var SourceType = "POSITIVE" # Can be "POSITIVE" or "NEGATIVE"
export(Vector2) var drag_offset = Vector2(-32, -100)
export(float, 0, 1.0) var drag_opacity = 0.7

var is_active = true

func _ready():
	update_logic()

func update_logic():
	# Determine state based on the name
	if SourceType.to_upper() == "POSITIVE":
		is_active = true
	else:
		is_active = false
	
	# Visual feedback: Violet for Active, Dark for Inactive
	if is_active:
		self.modulate = Color(1.5, 1.5, 2.0) # Bright Violet/Glow
	else:
		self.modulate = Color(0.3, 0.3, 0.3) # Dark Grey
	
	# Important for the Parallel System: Notify the chain!
	yield(get_tree(), "idle_frame") # Ensures listeners are ready
	emit_signal("signal_updated", is_active)

# --- Drag and Drop (Matches your Gate script for swapping) ---

#func get_drag_data(_position):
#	var data = {
#		"texture": texture,
#		"source_type": SourceType,
#		"source_node": self 
#	}
#
#	# Preview setup
#	var container = Control.new()
#	var drag_preview = TextureRect.new()
#	drag_preview.texture = texture
#	drag_preview.expand = true
#	drag_preview.rect_size = Vector2(64, 64)
#	drag_preview.modulate = Color(1, 1, 1, drag_opacity) 
#	drag_preview.rect_position = drag_offset
#	container.add_child(drag_preview)
#	set_drag_preview(container)
#
#	return data
#
#func can_drop_data(_position, data):
#	# Allow swapping if the dropped item has a source_node reference
#	return typeof(data) == TYPE_DICTIONARY and data.has("source_node")
#
#func drop_data(_position, data):
#	var partner_node = data["source_node"]
#
#	# 1. Swap the visual and logic data
#	partner_node.texture = self.texture
#	# Check if we are swapping with another Source or a Gate
#	if "SourceType" in partner_node:
#		partner_node.SourceType = self.SourceType
#
#	self.texture = data["texture"]
#	if data.has("source_type"):
#		self.SourceType = data["source_type"]
#
#	# 2. Refresh both nodes so the circuit updates
#	partner_node.update_logic()
#	self.update_logic()
