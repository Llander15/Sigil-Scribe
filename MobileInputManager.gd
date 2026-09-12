extends Node

# CHANGE THIS PATH to your icon's file location inside your res:// folder
export(String, FILE, "*.png,*.jpg,*.svg") var close_button_icon_path: String = "res://Assets/close.png"

var active_target: LineEdit = null
var canvas_layer: CanvasLayer
var overlay_panel: Control
var top_bar: Panel
var overlay_input: LineEdit
var close_button: TextureButton

func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 128
	canvas_layer.pause_mode = Node.PAUSE_MODE_PROCESS
	add_child(canvas_layer)
	
	var viewport_size = get_viewport().get_visible_rect().size
	var panel_height: float = 100.0
	
	# 1. Full-Screen Invisible Blocker
	overlay_panel = Control.new()
	overlay_panel.visible = false
	overlay_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay_panel.pause_mode = Node.PAUSE_MODE_PROCESS
	overlay_panel.rect_size = viewport_size
	overlay_panel.rect_position = Vector2.ZERO
	canvas_layer.add_child(overlay_panel)
	overlay_panel.connect("gui_input", self, "_on_overlay_gui_input")
	
	# 2. Visual Top Panel
	top_bar = Panel.new()
	top_bar.mouse_filter = Control.MOUSE_FILTER_STOP
	top_bar.pause_mode = Node.PAUSE_MODE_PROCESS
	top_bar.rect_size = Vector2(viewport_size.x, panel_height)
	top_bar.rect_position = Vector2.ZERO
	overlay_panel.add_child(top_bar)
	
	# 3. Input Field (Set anchors first)
	overlay_input = LineEdit.new()
	overlay_input.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay_input.pause_mode = Node.PAUSE_MODE_PROCESS
	overlay_input.anchor_left = 0.05
	overlay_input.anchor_right = 0.70 # Takes up 70% of top bar
	overlay_input.anchor_top = 0.2
	overlay_input.anchor_bottom = 0.8
	top_bar.add_child(overlay_input)
	
	overlay_input.connect("text_changed", self, "_on_text_changed")
	overlay_input.connect("text_entered", self, "_on_text_submitted")
	
	# 4. Close Button (Positioned relative to LineEdit)
	close_button = TextureButton.new()
	close_button.mouse_filter = Control.MOUSE_FILTER_STOP
	close_button.pause_mode = Node.PAUSE_MODE_PROCESS
	
	var button_y: float = 20.0
	if close_button_icon_path != "" and ResourceLoader.exists(close_button_icon_path):
		var tex: Texture = load(close_button_icon_path)
		close_button.texture_normal = tex
		button_y = (panel_height - tex.get_height()) / 2.0
	
	# Calculate LineEdit's right edge X position in pixels
	var line_edit_right_x: float = viewport_size.x * overlay_input.anchor_right
	var gap_pixels: float = 24.0 # Set your desired gap (e.g., 16.0, 24.0, or 32.0)
	
	# Place close button right after LineEdit + gap
	close_button.rect_position = Vector2(line_edit_right_x + gap_pixels, button_y)
	close_button.connect("pressed", self, "_close_overlay")
	top_bar.add_child(close_button)

func register_input(target: LineEdit) -> void:
	target.virtual_keyboard_enabled = false 
	target.connect("gui_input", self, "_on_target_gui_input", [target])

func _on_target_gui_input(event: InputEvent, target: LineEdit) -> void:
	if event is InputEventScreenTouch and event.pressed:
		active_target = target
		overlay_input.text = target.text
		
		# Sync character length limit (0 means unlimited)
		overlay_input.max_length = target.max_length
		
		# Sync secret/password settings
		overlay_input.secret = target.secret
		overlay_input.secret_character = target.secret_character
		
		# Copy custom font if available
		var font: Font = target.get_font("font")
		if font:
			overlay_input.add_font_override("font", font)
			
		overlay_panel.visible = true
		overlay_input.grab_focus()

func _on_overlay_gui_input(event: InputEvent) -> void:
	# Accept and consume touch events on the overlay so they never reach game nodes behind
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		get_viewport().set_input_as_handled()

func _on_text_changed(new_text: String) -> void:
	if active_target and is_instance_valid(active_target):
		active_target.text = new_text

func _on_text_submitted(_text: String) -> void:
	_close_overlay()

func _close_overlay() -> void:
	overlay_panel.visible = false
	OS.hide_virtual_keyboard()
	
	# Reset state defaults for next field
	overlay_input.secret = false
	overlay_input.max_length = 0
	
	if active_target and is_instance_valid(active_target):
		active_target.release_focus()
	active_target = null
