extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var volumeSLider = $NinePatchRect/VolumeSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	
	# 1. Load the previously saved volume from our SaveManager
	# Default to 0.8 (80%) if no save data exists yet
	var saved_volume = Data.save_data.get("volume_settings", {}).get("master", 0.8)
	
	# 2. Set the slider's visual position to the saved volume
	volumeSLider.value = saved_volume
	
	# 3. Apply the volume to the actual game audio
	set_bus_volume(saved_volume)
	
	# 4. Connect the slider's signal so it updates in real-time when dragged
	volumeSLider.connect("value_changed", self, "_on_volume_slider_value_changed")


func _on_volume_slider_value_changed(value: float):
	# Apply the volume to the game
	set_bus_volume(value)
	
	# Update our SaveManager data structure
	Data.save_data["volume_settings"]["master"] = value
	
	# Optional: Save immediately, or let the mobile focus-out handle it
	# SaveManager.save_game()


func set_bus_volume(value: float):
	# Find the index of the "Master" audio bus
	var bus_index = AudioServer.get_bus_index("Master")
	
	# Convert a 0.0–1.0 linear slider value into decibels (dB)
	# linear2db(0) is silent, linear2db(1) is 0dB (max original volume)
	var db_volume = linear2db(value)
	
	AudioServer.set_bus_volume_db(bus_index, db_volume)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Close_button_up():
	self.visible = false
	pass # Replace with function body.


func _on_Delete_Player_Saved_File_button_up():
	$"Delete Confirm Popup".visible = true
	$NinePatchRect.visible = false
	pass # Replace with function body.


func _on_Back_button_up():
	$NinePatchRect.visible = true
	pass # Replace with function body.


func _on_Confirm_button_up():
	print("confirm reset pressed")
	Data.reset_to_defaults()
	get_tree().change_scene("res://Welcome.tscn")
	if get_tree().paused:
		get_tree().paused = false
	pass # Replace with function body.
