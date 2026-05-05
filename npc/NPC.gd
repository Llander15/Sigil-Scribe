extends Area2D

export var npc_name : String = "Senior Scribe"
export(String, MULTILINE) var dialogue_text = "Welcome, Novice. Use the Logic Gauntlet to fix this circuit."

var is_player_nearby = false

onready var dialogue_ui = $CanvasLayer/NinePatchRect
onready var label = $CanvasLayer/NinePatchRect/Label

func _ready():
	dialogue_ui.hide() # Hide dialogue by default

func _input(event):
	# If player is close and presses "Interact" (Accept)
	if is_player_nearby and event.is_action_pressed("ui_accept"):
		toggle_dialogue()

func toggle_dialogue():
	if dialogue_ui.visible:
		dialogue_ui.hide()
	else:
		label.text = dialogue_text
		dialogue_ui.show()

# Connect these signals from the Area2D node
func _on_NPC_body_entered(body):
	if body.name == "Player":
		is_player_nearby = true
		# Optional: Show a "Press E to Talk" hint here
		toggle_dialogue()

func _on_NPC_body_exited(body):
	if body.name == "Player":
		is_player_nearby = false
		dialogue_ui.hide()
