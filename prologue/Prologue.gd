extends CanvasLayer

# Track the current index of the story
var current_step = 0

onready var anim_player = $AnimationPlayer

# The Narrative Data: Just the text for Aetheria
var story_data = [
	"In the floating islands of Eero, daily life runs smoothly thanks to the Great Schema—an orderly network of logic and data.",
	"Within the high stone walls of the Academy, you are a Student Scribe striving for promotion to a Higher Title Scribe.",
	"Guided by your Data Codex, your daily duties are to calibrate logic gates, queries archive tables, and pass your practical exams.",
	"Master these puzzles to earn your official rank, step beyond the Academy gates, and begin your journey as a full-fledged Scribe!"
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
	else:
		self.queue_free()

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
