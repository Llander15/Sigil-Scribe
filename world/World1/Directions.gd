extends Node2D

func _ready():
	clear_dirs()
	
	if Data.has_signal("mission_updated"):
		if not Data.is_connected("mission_updated", self, "_on_mission_updated"):
			Data.connect("mission_updated", self, "_on_mission_updated")
	
	_on_mission_updated()

func get_current_mission() -> int:
	return int(Data.save_data.get("mission_number", -1))

func clear_dirs():
	for child in self.get_children():
		if "visible" in child:
			child.visible = false

func _on_mission_updated(new_mission = -1):
	# Optional: If you prefer using the passed argument directly instead of calling get_current_mission()
	var current_mission = new_mission if new_mission != -1 else get_current_mission()
	
	match current_mission:
		0:
			clear_dirs()
			if has_node("dir_1"):
				$dir_1.visible = true
		1:
			clear_dirs()
			if has_node("dir_2"):
				$dir_2.visible = true
		2:
			clear_dirs()
			if has_node("dir_3"):
				$dir_3.visible = true
		3: 
			clear_dirs()
