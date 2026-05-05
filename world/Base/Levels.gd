extends Node2D

var target_player = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Popup.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		
		target_player = body
		
		body.get_node("Control/TouchScreen/ControlButtons/Interact").visible = true
		
		if not body.is_connected("interact_pressed", self, "_on_player_interacted"):
			body.connect("interact_pressed", self, "_on_player_interacted")
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		
		target_player = null
		
		body.get_node("Control/TouchScreen/ControlButtons/Interact").visible = false
		
		if body.is_connected("interact_pressed", self, "_on_player_interacted"):
			body.disconnect("interact_pressed", self, "_on_player_interacted")
		pass

func _on_player_interacted():
	print("Player touched the terminal!")
	
	#Freeze the world
	get_tree().paused = true
	
	$Popup.visible = true

func _on_Close_released():
	get_tree().paused = false
	
	$Popup.visible = false
	pass # Replace with function body.



func _on_Enter_released():
	get_tree().change_scene("res://world/World Test.tscn")
	get_tree().paused = false
	pass # Replace with function body.
