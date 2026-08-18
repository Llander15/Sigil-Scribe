extends TextureRect  # <--- Changed from Sprite to TextureRect

func _ready():
	visible = false  # Start hidden

func _process(_delta):
	if visible:
		# Follow the mouse cursor in real-time
		rect_global_position = get_global_mouse_position() - (rect_size / 2) # Centered on mouse

func _notification(what):
	if what == NOTIFICATION_DRAG_BEGIN:
		# Get the drag data payload sent by get_drag_data()
		var drag_data = get_viewport().gui_get_drag_data()
		
		# If the dragged data contains a texture, assign it automatically
		if typeof(drag_data) == TYPE_DICTIONARY and drag_data.has("texture"):
			texture = drag_data["texture"]
		
		visible = true
		
	elif what == NOTIFICATION_DRAG_END:
		visible = false
		texture = null
