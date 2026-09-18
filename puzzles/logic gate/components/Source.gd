extends TextureRect

signal signal_updated(state)

export(String) var SourceType = "POSITIVE" # Can be "POSITIVE" or "NEGATIVE"
export(Vector2) var drag_offset = Vector2(-32, -100)
export(float, 0, 1.0) var drag_opacity = 0.7

var is_active = true

func _ready():
	update_logic()

func update_logic():
	if SourceType.to_upper() == "POSITIVE":
		is_active = true
	else:
		is_active = false
	
	if is_active:
		self.modulate = Color(0.0, 1.0, 0.0)
	else:
		self.modulate = Color(0.8, 0.0, 0.0)
	
	yield(get_tree(), "idle_frame") 
	emit_signal("signal_updated", is_active)


