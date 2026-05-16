extends CanvasLayer

# Track the current index of the story
var current_step = 0

onready var anim_player = $AnimationPlayer

# The Narrative Data: Just the text for Aetheria
var story_data = [
	"For centuries, the floating islands of Aetheria were held aloft by the Great Schema—ancient veins of logic and data.",
	"But the Syntax Blight has struck. Logic gates have shorted, and the Void Tables have been locked.",
	"As the world falls into the abyss, only a Scribe can bridge the gap.",
	"Equipped with your Codex of Command, you must Refactor Aetheria... before the system crashes forever."
]

onready var label = $ColorRect/Label

func _ready():
	if not Data.save_data.has("ach"):
		Data.save_data["ach"] = []
		Data.save_game()
	if not "Prologue" in Data.save_data["ach"]:
		get_tree().paused = true 
		self.visible = true
		show_step()

func _input(event):
	# Progress on click, tap, or pressing Enter/Space
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		current_step += 1
		show_step()

func show_step():
	print("Showing step: ", current_step) 
	if current_step < story_data.size():
		label.text = story_data[current_step]
		
		if anim_player:
			anim_player.stop() # Rewind the player
			anim_player.play("FadeIn")
	else:
		end_prologue()

func end_prologue():
	if not "Prologue" in Data.save_data["ach"]:
		Data.save_data["ach"].append("Prologue")
		print("Prolouge seen")
	get_tree().paused = false
	# 1. Play the fade out animation
	if anim_player.has_animation("ScreenFadeOut"):
		anim_player.play("ScreenFadeOut")
		
		# 2. Wait for the animation to finish before moving on
		yield(anim_player, "animation_finished")
	
	# 3. Resume the game and clean up
	self.queue_free()
