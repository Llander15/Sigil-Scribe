extends Panel

export(String) var sql_text = "SELECT"

func _ready():
	# Ensure the label ignores the mouse so it doesn't block the Panel's drag
	if has_node("Label"):
		$Label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$Label.align = Label.ALIGN_CENTER
		$Label.valign = Label.VALIGN_CENTER
	update_text_display()

func update_text_display():
	if has_node("Label"):
		$Label.text = sql_text

# --- DRAG LOGIC ---
func get_drag_data(_position):
	var data = {
		"sql_content": sql_text,
		"origin_node": self
	}
	
	# Create a preview that looks like the panel
	var drag_preview = Panel.new()
	drag_preview.rect_size = self.rect_size
	drag_preview.modulate = Color(1, 1, 1, 0.7)
	
	# Add text to the preview so the player sees what they are moving
	var label_preview = Label.new()
	label_preview.text = sql_text
	label_preview.rect_size = drag_preview.rect_size
	label_preview.align = Label.ALIGN_CENTER
	label_preview.valign = Label.VALIGN_CENTER
	drag_preview.add_child(label_preview)
	
	# MOBILE OFFSET (Pivot Method)
	var pivot = Control.new()
	pivot.add_child(drag_preview)
	drag_preview.rect_position = Vector2(-drag_preview.rect_size.x / 2, -100) # Centered and Above
	
	set_drag_preview(pivot)
	return data

# --- DROP LOGIC ---
func can_drop_data(_position, data):
	return typeof(data) == TYPE_DICTIONARY and data.has("sql_content")

func drop_data(_position, data):
	var origin = data["origin_node"]
	
	# The String Swap
	var temp_text = self.sql_text
	self.sql_text = data["sql_content"]
	origin.sql_text = temp_text
	
	# Update both visuals
	self.update_text_display()
	origin.update_text_display()
