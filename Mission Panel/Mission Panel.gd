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
			mission_panel_label.text = "Mission: \n- Find Elder Scribe to get your first task."
		1:
			mission_panel_label.text = "Mission: \n- Get your tools inside the chest by solving a SQL puzzle\n- (Optional) Ask Elder Scribe for his favorite SQL Querry for hint."
		2:
			mission_panel_label.text = "Mission: \n- You have successfully recieved your tools, report back to Elder Scribe"
		3:
			mission_panel_label.text = "Mission: \n- Proceed to the next Scribe Instructor to recieve your next task."
		4:
			mission_panel_label.text = "Mission: \n- Interact with the torches and strengthen its fire with Digital Logic puzzles.\n- (Optional) Ask Scribe Instructor for help."
		5:
			mission_panel_label.text = "Mission:\n- You have successfully strengthen the torches, report back to Scribe Instructor."
		6:
			mission_panel_label.text = "Mission: \n- Repair the broken moving platform with Digital Logic puzzle."
		7:
			mission_panel_label.text = "Mission: \n- Latest mission is reached, kindly wait for our next expansion.\n- Thank you for playing."
		8:
			mission_panel_label.text = "Mission: \n- Latest mission is reached, kindly wait for our next expansion.\n- Thank you for playing."
		9:
			mission_panel_label.text = "Mission: \n- Latest mission is reached, kindly wait for our next expansion.\n- Thank you for playing."
		10:
			mission_panel_label.text = "Mission: \n- Latest mission is reached, kindly wait for our next expansion.\n- Thank you for playing."
		11:
			mission_panel_label.text = "Mission: \n- Latest mission is reached, kindly wait for our next expansion.\n- Thank you for playing."
		12:
			mission_panel_label.text = "Mission: \n- Latest mission is reached, kindly wait for our next expansion.\n- Thank you for playing."
		13:
			mission_panel_label.text = "Mission: \n- Latest mission is reached, kindly wait for our next expansion.\n- Thank you for playing."
		14:
			mission_panel_label.text = "Mission: \n- Latest mission is reached, kindly wait for our next expansion.\n- Thank you for playing."
		

func _notification(what):
	match what:
		NOTIFICATION_PAUSED:
			self.visible = false
		NOTIFICATION_UNPAUSED:
			self.visible = true
