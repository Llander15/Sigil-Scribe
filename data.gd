# Data.gd
extends Node

signal auth_status_changed(success, message)
signal save_conflict_detected(cloud_data)

const SAVE_PATH = "user://savegame.json"
const AUTH_PATH = "user://auth.json"

var current_user_id = ""
var is_logged_in = false

# Default data structure
var save_data = {
	"coins": 100,
	"level": 1,
	"timestamp": 0,
	"player_tutorial": true,
	"volume_settings": {"master": 0.8, "music": 1.0, "sfx": 1.0},
	"ach": [],
	"player_position": {"x": 0.0, "y": 0.0},
	"last_safe_position": {"x": 0.0, "y": 0.0}
}

func _ready():
	Firebase.Auth.connect("login_succeeded", self, "_on_login_succeeded")
	Firebase.Auth.connect("login_failed", self, "_on_login_failed")
	Firebase.Auth.connect("signup_succeeded", self, "_on_signup_succeeded")
	Firebase.Auth.connect("signup_failed", self, "_on_signup_failed")
	
	load_game()
	
	# Attempt auto-login if saved credentials exist
	_auto_login()

# -------------------------------------------------------------------
# AUTHENTICATION LOGIC & AUTO-LOGIN
# -------------------------------------------------------------------

func login_user(email: String, password: String):
	# Save credentials locally for auto-login on next launch
	_save_auth_credentials(email, password)
	Firebase.Auth.login_with_email_and_password(email, password)

func signup_user(email: String, password: String):
	# Save credentials locally for auto-login on next launch
	_save_auth_credentials(email, password)
	Firebase.Auth.signup_with_email_and_password(email, password)

func logout_user():
	is_logged_in = false
	current_user_id = ""
	_clear_auth_credentials()
	emit_signal("auth_status_changed", false, "Logged out.")

func _auto_login():
	var file = File.new()
	if file.file_exists(AUTH_PATH):
		if file.open(AUTH_PATH, File.READ) == OK:
			var json_result = JSON.parse(file.get_as_text())
			file.close()
			
			if json_result.error == OK and json_result.result is Dictionary:
				var auth_data = json_result.result
				var email = auth_data.get("email", "")
				var password = auth_data.get("password", "")
				
				if email != "" and password != "":
					emit_signal("auth_status_changed", true, "Auto-logging in...")
					Firebase.Auth.login_with_email_and_password(email, password)

func _save_auth_credentials(email: String, password: String):
	var auth_data = {
		"email": email,
		"password": password
	}
	var file = File.new()
	if file.open(AUTH_PATH, File.WRITE) == OK:
		file.store_string(to_json(auth_data))
		file.close()

func _clear_auth_credentials():
	var dir = Directory.new()
	if dir.file_exists(AUTH_PATH):
		dir.remove(AUTH_PATH)

func _on_login_succeeded(auth_info):
	current_user_id = auth_info.localid
	is_logged_in = true
	emit_signal("auth_status_changed", true, "Logged in successfully!")
	fetch_cloud_data()

func _on_signup_succeeded(auth_info):
	current_user_id = auth_info.localid
	is_logged_in = true
	emit_signal("auth_status_changed", true, "Account created! Linking local save...")
	upload_to_cloud()

func _on_login_failed(code, message):
	emit_signal("auth_status_changed", false, "Login Failed: " + message)

func _on_signup_failed(code, message):
	emit_signal("auth_status_changed", false, "Registration Failed: " + message)

# -------------------------------------------------------------------
# SAVE & LOAD LOGIC
# -------------------------------------------------------------------

func save_game():
	save_data["timestamp"] = OS.get_unix_time()
	save_locally_only()
	
	if is_logged_in and current_user_id != "":
		upload_to_cloud()

func save_locally_only():
	var file = File.new()
	if file.open(SAVE_PATH, File.WRITE) == OK:
		file.store_string(to_json(save_data))
		file.close()

func load_game():
	var file = File.new()
	if not file.file_exists(SAVE_PATH):
		save_game()
		return

	if file.open(SAVE_PATH, File.READ) == OK:
		var json_result = JSON.parse(file.get_as_text())
		file.close()
		if json_result.error == OK:
			save_data = json_result.result

# -------------------------------------------------------------------
# CLOUD FIRESTORE SYNC
# -------------------------------------------------------------------

func upload_to_cloud():
	if not is_logged_in or current_user_id == "":
		return
		
	var collection: FirestoreCollection = Firebase.Firestore.collection("players")
	var doc: FirestoreDocument = FirestoreDocument.new()
	doc.doc_name = current_user_id
	
	for key in save_data.keys():
		doc.add_or_update_field(key, save_data[key])
		
	var task = collection.update(doc)
	yield(task, "completed")

func fetch_cloud_data():
	if not is_logged_in or current_user_id == "":
		return
		
	var collection: FirestoreCollection = Firebase.Firestore.collection("players")
	var task = collection.get_doc(current_user_id)
	var response = yield(task, "completed")
	
	if response is FirestoreDocument and response.doc_name != "":
		var cloud_data = {}
		for key in response.keys():
			cloud_data[key] = response.get_value(key)
			
		var cloud_timestamp = int(cloud_data.get("timestamp", 0))
		var local_timestamp = int(save_data.get("timestamp", 0))
		
		if local_timestamp > 0 and cloud_timestamp > 0 and local_timestamp != cloud_timestamp:
			emit_signal("save_conflict_detected", cloud_data)
		elif cloud_timestamp > local_timestamp:
			apply_cloud_save(cloud_data)
		else:
			upload_to_cloud()
	else:
		upload_to_cloud()

func apply_cloud_save(cloud_data: Dictionary):
	save_data = cloud_data
	save_locally_only()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT or what == MainLoop.NOTIFICATION_APP_PAUSED:
		save_game()

# -------------------------------------------------------------------
# HELPER GETTERS & SETTERS
# -------------------------------------------------------------------

func set_last_safe_position(pos: Vector2) -> void:
	save_data["last_safe_position"] = {"x": pos.x, "y": pos.y}

func get_last_safe_position() -> Vector2:
	var pos = save_data.get("last_safe_position", null)
	if pos is Vector2:
		return pos
	if pos is Dictionary and pos.has("x") and pos.has("y"):
		if pos.x != null and pos.y != null:
			return Vector2(float(pos.x), float(pos.y))
	return Vector2.ZERO

func set_player_position(pos: Vector2) -> void:
	save_data["player_position"] = {"x": pos.x, "y": pos.y}

func get_player_position() -> Vector2:
	var pos = save_data.get("player_position", null)
	if pos is Vector2:
		return pos
	if pos is Dictionary and pos.has("x") and pos.has("y"):
		if pos.x != null and pos.y != null:
			return Vector2(float(pos.x), float(pos.y))
	return Vector2.ZERO

func reset_to_defaults():
	save_data = {
		"coins": 100,
		"level": 1,
		"timestamp": OS.get_unix_time(),
		"player_tutorial": true,
		"volume_settings": {"master": 0.8, "music": 1.0, "sfx": 1.0},
		"ach": [],
		"player_position": {"x": 0.0, "y": 0.0},
		"last_safe_position": {"x": 0.0, "y": 0.0}
	}
	save_game()
