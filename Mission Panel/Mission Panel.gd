extends Control

onready var mission_panel_label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Data.connect("mission_updated", self, "update_mission_panel")
	
	var mission_number = Data.save_data["mission_number"]
	update_mission_panel(mission_number)



func update_mission_panel(mission_id: int = -1): #mission starts at 0
	# Safety check in case the label isn't ready or path is missing
	if not is_instance_valid(mission_panel_label):
		mission_panel_label = $Label # Re-fetch or adjust path here
		
	if not mission_panel_label:
		return # Exit gracefully if label still doesn't exist
	match mission_id:
		0:
			mission_panel_label.text = "Mission: \n- Find Zor, the Elder Scribe to get your first task."
		1:
			mission_panel_label.text = "Mission: \n- Get your tools inside the chest by solving a SQL puzzle\n- (Optional) Ask Zor for his favorite SQL Querry for hint."
		2:
			mission_panel_label.text = "Mission: \n- You have successfully recieved your tools, report back to Elder Scribe"
		3:
			mission_panel_label.text = "Mission: \n- Proceed to the next Scribe Instructor George to recieve your next task."
		4:
			mission_panel_label.text = "Mission: \n- Strengthen the fire of the torches with Digital Logic puzzles.\n- (Optional) Ask George for help."
		5:
			mission_panel_label.text = "Mission:\n- You have successfully strengthen the torches, report back to George."
		6:
			mission_panel_label.text = "Mission: \n- Repair the broken moving platform with Digital Logic puzzle."
		7:
			mission_panel_label.text = "Mission: \n- Platform is now fixed and working! Meet Scribe Instructor Alea at the top of the cliff."
		8:
			mission_panel_label.text = "Mission: \n- Locate and strengthen the remaining torches.\n (Optional) Read Data Codex (Book Logo on top) and learn more about the Digital Logic Gates."
		9:
			mission_panel_label.text = "Mission: \n- All torches now are strengthen! Report back to Alea for your next task."
		10:
			mission_panel_label.text = "Mission: \n- Open the gate to become a full-fledge Scribe."
		11:
			mission_panel_label.text = "Mission: \n- Report back to Alea.."
		12:
			mission_panel_label.text = "Mission: \n- Equip your Novice Scribe Badge."
		13:
			mission_panel_label.text = "Mission: \n- Report back to Alea."
		14:
			mission_panel_label.text = "Mission: \n- Talk to the girl outside the gate."
		15:
			mission_panel_label.text = "Mission: \n- Activate the bridge."
		16:
			mission_panel_label.text = "Mission: \n- Tell the girl you successfully activated the bridge."
		17:
			mission_panel_label.text = "Mission: \n- You have recieved payment, look for a shop to see available goods."
		18:
			mission_panel_label.text = "Mission: \n- Buy an item from Shopkeeper."
		
		
		_:
			mission_panel_label.text = "Mission: \n- Latest mission is reached, kindly wait for our next expansion.\n- Thank you for playing "

func _notification(what):
	match what:
		NOTIFICATION_PAUSED:
			self.visible = false
		NOTIFICATION_UNPAUSED:
			self.visible = true
