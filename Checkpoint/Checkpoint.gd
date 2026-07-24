extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		Global.last_safe_position = self.global_position
		Data.save_data["last_safe_position"] = self.global_position
		print("Checkpoint Saved!")
		
		#update player last position
		Data.save_data["player_position"]["x"] = self.global_position.x
		Data.save_data["player_position"]["y"] = self.global_position.y
		print("updated player last position")
		# You can change the flag color or play an animation here
	pass # Replace with function body.
