tool
extends Label

export(String) var sql_text = "SELECT" setget set_sql_text

func _ready():
	# MOUSE_FILTER_PASS allows dragging while still registering clicks properly
	self.mouse_filter = Control.MOUSE_FILTER_PASS
	self.align = Label.ALIGN_CENTER
	self.valign = Label.VALIGN_CENTER
	
	update_text_display()

# This updates the size inside the Godot editor immediately when you type
func set_sql_text(new_value):
	sql_text = new_value
	if is_inside_tree():
		update_text_display()

func update_text_display():
	self.text = sql_text
	
	# 1. Fetch the custom font override, or fall back to the default theme font
	var font = get_font("font")
	if not font:
		font = Control.new().get_font("font") # Fallback to engine default if needed
	
	# 2. Measure string dimensions
	var text_size = font.get_string_size(self.text)
	
	# 3. Add horizontal padding (20px left + 20px right = 40px)
	var padding = 40
	var new_width = text_size.x + padding
	var new_height = 50 # Standard height row for the SQL builder
	
	# 4. Set the minimum size so the HFlowContainer/HBoxContainer can arrange it
	self.rect_min_size = Vector2(new_width, new_height)

# --- DRAG LOGIC ---
func get_drag_data(_position):
	# Tool mode safety: don't allow dragging inside the editor window workspace
	if Engine.editor_hint:
		return null
		
	var data = {
		"sql_content": sql_text,
		"origin_node": self
	}
	
	# Create the drag preview label
	var drag_preview = Label.new()
	drag_preview.text = sql_text
	drag_preview.rect_size = self.rect_size
	drag_preview.align = Label.ALIGN_CENTER
	drag_preview.valign = Label.VALIGN_CENTER
	drag_preview.modulate = Color(1, 1, 1, 0.7)
	
	# Carry over your StyleBox background styling to the floating preview
	var current_style = get_stylebox("normal")
	if current_style:
		drag_preview.add_stylebox_override("normal", current_style)
	
	# Mobile/Mouse Offset Pivot (Keeps preview visible above finger/cursor)
	var pivot = Control.new()
	pivot.add_child(drag_preview)
	drag_preview.rect_position = Vector2(-drag_preview.rect_size.x / 2, -100)
	
	set_drag_preview(pivot)
	return data

# --- DROP LOGIC ---
func can_drop_data(_position, data):
	if Engine.editor_hint:
		return false
	return typeof(data) == TYPE_DICTIONARY and data.has("sql_content")

func drop_data(_position, data):
	var origin = data["origin_node"]
	
	# Swap text contents between the two labels
	var temp_text = self.sql_text
	self.sql_text = data["sql_content"]
	origin.sql_text = temp_text
	
	# Refresh text lengths and container sizing bounds
	self.update_text_display()
	origin.update_text_display()
