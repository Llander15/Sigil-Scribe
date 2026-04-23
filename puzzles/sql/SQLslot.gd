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
		var label = $Label
		label.text = sql_text
		
		# 1. Get the font being used by the label
		# This looks for a custom font, otherwise uses the default
		var font = label.get_font("font")
		
		# 2. Calculate the width of the string
		var text_size = font.get_string_size(label.text)
		
		# 3. Add some "Padding" (e.g., 20 pixels on each side)
		var padding = 40
		var new_width = text_size.x + padding
		var new_height = 50 # Keep height consistent for the row
		
		# 4. Apply the size to the Label AND the Panel
		# We use min_size because we are inside a Container
		label.rect_min_size = Vector2(new_width, new_height)
		self.rect_min_size = Vector2(new_width, new_height)
		
		# Optional: Ensure the HBox updates its layout immediately
# Check if the parent is actually a container before calling the function
		var parent = get_parent()
		if parent is Container:
			parent.queue_sort() 
		else:
			# If the parent is a NinePatchRect, it doesn't sort. 
			# You might need to reach one level higher to find the HBox.
			var grand_parent = parent.get_parent()
			if grand_parent is Container:
				grand_parent.queue_sort()

	var wrapper = get_parent()
	if wrapper is Control and not wrapper is Container:
		wrapper.rect_min_size = self.rect_min_size

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
