extends CanvasLayer

########################### Profile ###########################
onready var profile_details = $ProfileDetails
onready var profile_btn = $ProfileButton
onready var small_player_level = $SmallPlayerLevel

func _ready():
	if $"..".name == "TouchScreen": #if parent is TouchScreen Scene
		pass
	else: #else, currently only Welcome Scene
		small_player_level.visible = false
		profile_btn.visible = false


func _on_ProfileButton_pressed():
	profile_details.visible = true
	profile_btn.visible = false
	small_player_level.visible = false
	
	if $"../ControlButtons":
		$"../ControlButtons".visible = false
	
	get_tree().paused = true

######################## Profile Details ######################
func _on_TouchScreenButton_pressed():
	profile_details.visible = false
	profile_btn.visible = true
	small_player_level.visible = true
	
	if $"../ControlButtons":
		$"../ControlButtons".visible = true
	
	get_tree().paused = false



############################# Stats ###########################
onready var upgrage_btn = $ProfileDetails/StatsDetails/Upgrade

onready var spd_pb = $ProfileDetails/StatsDetails/Speed/ProgressBar
onready var spd_edit = $ProfileDetails/StatsDetails/Speed/Upgrade
onready var jmp_ht_pb = $ProfileDetails/StatsDetails/JumpHeight/ProgressBar
onready var jmp_ht_edit = $ProfileDetails/StatsDetails/JumpHeight/Upgrade
onready var gold_yld_pb = $ProfileDetails/StatsDetails/GoldYield/ProgressBar
onready var gold_yld_edit = $ProfileDetails/StatsDetails/GoldYield/Upgrade
onready var exp_yld_pb = $ProfileDetails/StatsDetails/ExpYield/ProgressBar
onready var exp_yld_edit = $ProfileDetails/StatsDetails/ExpYield/Upgrade

onready var upgrading = false

func _on_Upgrade_pressed():
	if not upgrading:
		upgrage_btn.text = "Confirm"
		
		_update_Stats_View()
		upgrading = !upgrading
	else:
		upgrage_btn.text = "Upgrade"
		
		_update_Stats_View()
		upgrading = !upgrading
	pass # Replace with function body.

func _update_Stats_View():
	spd_pb.visible = !spd_pb.visible
	jmp_ht_pb.visible = !jmp_ht_pb.visible
	gold_yld_pb.visible = !gold_yld_pb.visible
	exp_yld_pb.visible = !exp_yld_pb.visible
	
	spd_edit.visible = !spd_edit.visible
	jmp_ht_edit.visible = !jmp_ht_edit.visible
	gold_yld_edit.visible = !gold_yld_edit.visible
	exp_yld_edit.visible = !exp_yld_edit.visible



