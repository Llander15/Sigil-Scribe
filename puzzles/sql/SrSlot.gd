extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var state = "ONE"
# Called when the node enters the scene tree for the first time.
func _ready():
	updateState()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SrSlot_pressed():
	if state=="ONE":
		state = "MANY"
		updateState()
	else:
		state = "ONE"
		updateState()
	pass # Replace with function body.

func updateState():
	if state == "ONE":
		$MANY.visible = false
	else:
		$MANY.visible = true
	pass
