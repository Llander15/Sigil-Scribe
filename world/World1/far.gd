extends ParallaxLayer

func _process(delta) -> void:
	self.motion_offset.x += -8 * delta
