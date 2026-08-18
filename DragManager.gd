# DragManager.gd
extends Node

# 1. Preload your "dragging hand" cursor texture directly inside this script
var hand_texture = preload("res://icon32.png") # Change path to your asset!

var drag_sprite: Sprite = null

func _ready():
	# Create the drag hand sprite node programmatically
	drag_sprite = Sprite.new()
	drag_sprite.texture = hand_texture # Assign the dragging hand icon!
	drag_sprite.visible = false
	drag_sprite.z_index = 4096 # Draw on top of everything
	
	get_tree().root.call_deferred("add_child", drag_sprite)

func _process(_delta):
	# Follow the mouse pointer in real time
	if drag_sprite and drag_sprite.visible:
		drag_sprite.global_position = drag_sprite.get_global_mouse_position()

# --- CALLABLE FROM ANYWHERE ---

# Call this when any drag operation starts
func start_drag():
	if drag_sprite:
		drag_sprite.visible = true

# Call this when the drag ends
func stop_drag():
	if drag_sprite:
		drag_sprite.visible = false
