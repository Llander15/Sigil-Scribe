extends Control

onready var email_input = $VBoxContainer/EmailInput
onready var password_input = $VBoxContainer/PasswordInput
onready var status_label = $VBoxContainer/StatusLabel

onready var login_btn = $VBoxContainer/HBoxContainer/LoginBtn
onready var register_btn = $VBoxContainer/HBoxContainer/RegisterBtn
onready var conflict_dialog = $ConflictDialog

var pending_cloud_data = {}

func _ready():
	# Connect UI buttons
	login_btn.connect("pressed", self, "_on_login_pressed")
	register_btn.connect("pressed", self, "_on_register_pressed")
	
	# Connect Data singleton conflict signals
	Data.connect("save_conflict_detected", self, "_on_save_conflict_detected")
	Data.connect("auth_status_changed", self, "_on_auth_status_changed")

	# Setup Conflict Dialog choices
	conflict_dialog.dialog_text = "A cloud save was found that differs from your local offline progress. Which save do you want to keep?"
	conflict_dialog.get_ok().text = "Keep Local Progress"
	conflict_dialog.add_button("Keep Cloud Save", true, "use_cloud")
	conflict_dialog.connect("confirmed", self, "_on_keep_local_chosen")
	conflict_dialog.connect("custom_action", self, "_on_keep_cloud_chosen")

func _on_login_pressed():
	var email = email_input.text.strip_edges()
	var password = password_input.text.strip_edges()
	if email == "" or password == "":
		status_label.text = "Please fill in all fields."
		return
	
	status_label.text = "Logging in..."
	Data.login_user(email, password)

func _on_register_pressed():
	var email = email_input.text.strip_edges()
	var password = password_input.text.strip_edges()
	if email == "" or password == "":
		status_label.text = "Please fill in all fields."
		return
	
	if password.length() < 6:
		status_label.text = "Password must be at least 6 characters."
		return

	status_label.text = "Creating account..."
	# Registering automatically uploads current offline save to new account
	Data.signup_user(email, password)

func _on_auth_status_changed(success: bool, message: String):
	status_label.text = message
	if success:
		# If no conflict dialog was popped, transition to main game
		yield(get_tree().create_timer(1.0), "timeout")
		if not conflict_dialog.visible:
			get_tree().change_scene("res://Welcome.tscn")

# -------------------------------------------------------------------
# CONFLICT RESOLUTION HANDLERS
# -------------------------------------------------------------------

func _on_save_conflict_detected(cloud_data: Dictionary):
	pending_cloud_data = cloud_data
	
	var local_time = OS.get_datetime_from_unix_time(Data.save_data.get("timestamp", 0))
	var cloud_time = OS.get_datetime_from_unix_time(cloud_data.get("timestamp", 0))
	
	conflict_dialog.dialog_text = "Save Conflict Found!\n\n" \
		+ "Local Save Level: " + str(Data.save_data.get("level", 1)) + "\n" \
		+ "Cloud Save Level: " + str(cloud_data.get("level", 1)) + "\n\n" \
		+ "Which save file would you like to keep?"
		
	conflict_dialog.popup_centered()

func _on_keep_local_chosen():
	# Overwrite cloud with local progress
	Data.upload_to_cloud()
	get_tree().change_scene("res://Welcome.tscn")

func _on_keep_cloud_chosen(action):
	if action == "use_cloud":
		# Overwrite local save with cloud progress
		Data.apply_cloud_save(pending_cloud_data)
		get_tree().change_scene("Welcome.tscn")
