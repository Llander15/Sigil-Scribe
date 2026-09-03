extends Node

const SAVE_PATH = "user://player_data.json"

var current_user_id = ""
var is_logged_in = false

# Default save structure
var player_data = {
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

func _ready():
	# Connect to GodotFirebase signals
	Firebase.Auth.connect("login_succeeded", self, "_on_login_succeeded")
	Firebase.Auth.connect("login_failed", self, "_on_login_failed")
	
	# Load existing local save on startup
	load_local_data()

# -------------------------------------------------------------------
# AUTHENTICATION
# -------------------------------------------------------------------

func login_user(email: String, password: String):
	Firebase.Auth.login_with_email_and_password(email, password)

func signup_user(email: String, password: String):
	Firebase.Auth.signup_with_email_and_password(email, password)

func _on_login_succeeded(auth_info):
	current_user_id = auth_info.localid
	is_logged_in = true
	print("Logged in successfully. UID: ", current_user_id)
	
	# Fetch cloud data to sync across devices
	fetch_cloud_data()

func _on_login_failed(code, message):
	print("Login failed: ", message)

# -------------------------------------------------------------------
# SAVE & LOAD LOGIC (LOCAL + CLOUD)
# -------------------------------------------------------------------

func save_game():
	player_data["timestamp"] = OS.get_unix_time()
	
	# 1. Save locally first (Works 100% offline)
	var file = File.new()
	if file.open(SAVE_PATH, File.WRITE) == OK:
		file.store_string(to_json(player_data))
		file.close()
		print("Game saved locally.")
	
	# 2. Upload to Firestore if logged in
	if is_logged_in and current_user_id != "":
		upload_to_cloud()

func upload_to_cloud():
	if not is_logged_in or current_user_id == "":
		return
		
	var collection: FirestoreCollection = Firebase.Firestore.collection("players")
	
	# Construct FirestoreDocument targeting the user's UID
	var doc: FirestoreDocument = FirestoreDocument.new()
	doc.doc_name = current_user_id
	
	for key in player_data.keys():
		# Using the correct function from FirestoreDocument class
		doc.add_or_update_field(key, player_data[key])
		
	var task = collection.update(doc)
	yield(task, "completed")
	print("Cloud document saved successfully!")

func fetch_cloud_data():
	if not is_logged_in or current_user_id == "":
		return
		
	var collection: FirestoreCollection = Firebase.Firestore.collection("players")
	var task = collection.get_doc(current_user_id)
	var response = yield(task, "completed")
	
	if response is FirestoreDocument and response.doc_name != "":
		# Extract dictionary using FirestoreDocument methods
		var cloud_data = {}
		for key in response.keys():
			cloud_data[key] = response.get_value(key)
			
		var cloud_timestamp = int(cloud_data.get("timestamp", 0))
		var local_timestamp = int(player_data.get("timestamp", 0))
		
		if cloud_timestamp > local_timestamp:
			player_data = cloud_data
			
			var file = File.new()
			if file.open(SAVE_PATH, File.WRITE) == OK:
				file.store_string(to_json(player_data))
				file.close()
			print("Local save updated from Cloud.")
		elif local_timestamp > cloud_timestamp:
			print("Local save is newer. Uploading offline progress to Cloud...")
			upload_to_cloud()
		else:
			print("Local and Cloud saves are in sync.")
	else:
		print("No cloud record found for this user. Uploading baseline save...")
		upload_to_cloud()

func load_local_data():
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		if file.open(SAVE_PATH, File.READ) == OK:
			var text = file.get_as_text()
			file.close()
			var parse_result = parse_json(text)
			if typeof(parse_result) == TYPE_DICTIONARY:
				player_data = parse_result
