extends Camera2D

onready var player = $"../World1/Player"
onready var camera = $"."


func _ready():
	# Set the zoom higher to see the map (2.0 = 2x zoomed out) 
	pass



func _physics_process(_delta):
	if player:
		# Follow the player's position
		camera.position = player.position
#		print("Minimap Camera Position: ", position)
