extends TextureRect

# 1. Triggered when you click and drag the TextureRect
func get_drag_data(position):
	# Use the current texture as the drag data
	var data = texture
	
	# Optional: Make a preview so the icon follows the mouse
	var drag_preview = TextureRect.new()
	drag_preview.texture = texture
	drag_preview.expand = true
	drag_preview.rect_size = Vector2(64, 64) # Adjust size as needed
	set_drag_preview(drag_preview)
	
	return data

# 2. Triggered when dragging something OVER this TextureRect
func can_drop_data(position, data):
	# Only allow dropping if the data is a Texture
	return data is Texture

# 3. Triggered when you release the mouse over this TextureRect
func drop_data(position, data):
	texture = data
