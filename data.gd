extends Node

const SAVE_PATH = "user://savegame.json"

# Default data structure
var save_data = {
	"player_tutorial": true,
	"volume_settings": {
		"master": 0.8,
		"music": 1.0,
		"sfx": 1.0
	},
	"ach": [],
	"player_position": {
		"x": 0.0,
		"y": 0.0
	},
	"last_safe_position": {
		"x": 0.0,
		"y": 0.0
	}
}

func _ready():
	load_game()

# Call this to write data to the mobile device
func save_game():
	var file = File.new()
	var error = file.open(SAVE_PATH, File.WRITE)
	
	if error == OK:
		# to_json() converts the dictionary into a string in Godot 3
		file.store_string(to_json(save_data))
		file.close()
		print("Game Saved Successfully!")
	else:
		print("An error occurred while trying to save data. Code: ", error)

# Automatically called on game start
func load_game():
	var file = File.new()
	if not file.file_exists(SAVE_PATH):
		print("No save file found. Creating a new one with defaults.")
		save_game() 
		return

	var error = file.open(SAVE_PATH, File.READ)
	if error == OK:
		var json_string = file.get_as_text()
		file.close()
		
		# Godot 3 JSON parsing
		var json_result = JSON.parse(json_string)
		if json_result.error == OK:
			save_data = json_result.result
			print("Game Loaded Successfully!")
		else:
			print("JSON Parse Error: ", json_result.error_string, " at line ", json_result.error_line)
	else:
		print("An error occurred while trying to load data. Code: ", error)

func reset_to_defaults():
	save_data = {
		"player_tutorial": true,
		"volume_settings": {
			"master": 0.8,
			"music": 1.0,
			"sfx": 1.0
		},
		"ach": [],
		"player_position": {
			"x": 0.0,
			"y": 0.0
		},
		"last_safe_position": {
			"x": 0.0,
			"y": 0.0
		}
	}

func _notification(what):
	# Triggers when the user minimizes the app or opens another app
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT or what == MainLoop.NOTIFICATION_APP_PAUSED:
		save_game()

# --- Vector2 Helpers for External Scripts ---

func set_last_safe_position(pos: Vector2) -> void:
	save_data["last_safe_position"] = {"x": pos.x, "y": pos.y}

func get_last_safe_position() -> Vector2:
	var pos = save_data.get("last_safe_position", null)
	
	# Handle Vector2 directly (if coming from legacy code or memory)
	if pos is Vector2:
		return pos
		
	# Handle Dictionary format (JSON data)
	if pos is Dictionary and pos.has("x") and pos.has("y"):
		if pos.x != null and pos.y != null:
			return Vector2(pos.x, pos.y)
			
	return Vector2.ZERO

func set_player_position(pos: Vector2) -> void:
	save_data["player_position"] = {"x": pos.x, "y": pos.y}

func get_player_position() -> Vector2:
	var pos = save_data.get("player_position", null)
	
	# Handle Vector2 directly
	if pos is Vector2:
		return pos
		
	# Handle Dictionary format
	if pos is Dictionary and pos.has("x") and pos.has("y"):
		if pos.x != null and pos.y != null:
			return Vector2(pos.x, pos.y)
			
	return Vector2.ZERO
