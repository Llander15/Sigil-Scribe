extends LineEdit

func _ready() -> void:
	MobileInputManager.register_input(self)
