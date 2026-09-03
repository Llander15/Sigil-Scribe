extends CanvasLayer

onready var master_slider = $NinePatchRect/VolumeSlider
# Add these if you have separate sliders for Music and SFX:
# onready var music_slider = $NinePatchRect/MusicSlider
# onready var sfx_slider = $NinePatchRect/SFXSlider

onready var main_panel = $NinePatchRect
onready var delete_popup = $"Delete Confirm Popup"

func _ready():
	self.visible = false
	delete_popup.visible = false
	main_panel.visible = true
	
	_load_and_apply_audio_settings()
	
	# Connect signals
	master_slider.connect("value_changed", self, "_on_master_slider_value_changed")

func _load_and_apply_audio_settings():
	var volume_settings = Data.save_data.get("volume_settings", {})
	
	var master_val = volume_settings.get("master", 0.8)
	var music_val = volume_settings.get("music", 1.0)
	var sfx_val = volume_settings.get("sfx", 1.0)
	
	master_slider.value = master_val
	# music_slider.value = music_val
	# sfx_slider.value = sfx_val
	
	set_bus_volume("Master", master_val)
	set_bus_volume("Music", music_val)
	set_bus_volume("SFX", sfx_val)

func _on_master_slider_value_changed(value: float):
	set_bus_volume("Master", value)
	
	if not Data.save_data.has("volume_settings"):
		Data.save_data["volume_settings"] = {}
		
	Data.save_data["volume_settings"]["master"] = value
	
	# FIXED: Aligned with baseline Data.gd save call
	Data.save_game()

# Optional handlers for separate audio streams
func _on_music_slider_value_changed(value: float):
	set_bus_volume("Music", value)
	if not Data.save_data.has("volume_settings"):
		Data.save_data["volume_settings"] = {}
	Data.save_data["volume_settings"]["music"] = value
	Data.save_game()

func _on_sfx_slider_value_changed(value: float):
	set_bus_volume("SFX", value)
	if not Data.save_data.has("volume_settings"):
		Data.save_data["volume_settings"] = {}
	Data.save_data["volume_settings"]["sfx"] = value
	Data.save_game()

func set_bus_volume(bus_name: String, value: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		# Convert linear 0.0-1.0 to decibels (-80dB to 0dB)
		var db_volume = linear2db(value)
		AudioServer.set_bus_volume_db(bus_index, db_volume)

# -------------------------------------------------------------------
# UI NAVIGATION & RESET POPUP HANDLERS
# -------------------------------------------------------------------

func _on_Close_pressed():
	self.visible = false

func _on_Delete_Player_Saved_File_pressed():
	delete_popup.visible = true
	main_panel.visible = false

func _on_Cancel_Reset_pressed():
	delete_popup.visible = false
	main_panel.visible = true

func _on_Confirm_pressed():
	print("Confirm reset pressed: Resetting local and cloud save data...")
	
	# Unpause engine if paused from a pause menu
	if get_tree().paused:
		get_tree().paused = false
		
	# Revert dictionary data structure back to defaults
	Data.save_data = {
	"level": 1,
	"total_exp": 0,
	"gold": 0,
	"stats":{"speed": 0, "jump_height": 0, "gold_yield": 0, "exp_yield": 0},
	"timestamp": 0,
	"player_tutorial": true,
	"volume_settings": {"master": 0.8, "music": 1.0, "sfx": 1.0},
	"ach": [],
	"player_position": {"x": 0.0, "y": 0.0},
	"last_safe_position": {"x": 0.0, "y": 0.0}
	}
	
	# FIXED: Save defaults locally and push to cloud if logged in
	Data.save_game()
		
	get_tree().change_scene("res://Welcome.tscn")
