extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
#	 Called every frame. 'delta' is the elapsed time since the previous frame.
	position = $"../Player".position
	pass
#func _process(delta):
#	pass
