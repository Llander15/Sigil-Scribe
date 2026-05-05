extends ViewportContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Viewport/World1/Player
	camera = $Viewport/World1/Camera2D
	pass # Replace with function body.


func _process(delta):
	if player:
		camera.position = player.position
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
