extends CanvasLayer
onready var mini_player = $Control/ViewportContainer/Viewport/mini_player
onready var player = $"../Player"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	mini_player.position = player.position
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
