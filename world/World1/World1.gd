extends Node2D

onready var player = $Player
onready var main_viewport = get_viewport()
onready var mini_viewport = $Control/ViewportContainer/Viewport
onready var mini_camera = $Control/ViewportContainer/Viewport/Camera2D

func _ready():
	yield(get_tree(), "idle_frame") 
	
	#mini_viewport.world_2d = main_viewport.world_2d
	
	if has_node("Player"):
		mini_camera.position = $Player.position 

func _physics_process(delta):
	mini_camera.position = player.position
	
	if 0>1: # this statement is for removing the "delta" not used in debugger
		print(delta)


func _on_reset_released():
	get_tree().reload_current_scene()
	pass # Replace with function body.

