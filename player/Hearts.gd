extends HBoxContainer

onready var heart_1 = $heart1
onready var heart_2 = $heart2
onready var heart_3 = $heart3
onready var tween = $Tween

var previous_hp: int = -1

func _ready():
	if Data.has_signal("health_updated"):
		if not Data.is_connected("health_updated", self, "_update_heart_output"):
			Data.connect("health_updated", self, "_update_heart_output")
	_update_heart_output()

func _update_heart_output():
	var hp = int(Data.save_data.get("current_health", 0))
	
	var is_hp_decreasing = previous_hp != -1 and hp < previous_hp
	previous_hp = hp
	
	var hearts = [heart_1, heart_2, heart_3]
	
	if is_hp_decreasing:
		# Instantly show updated state before delay
		_apply_base_colors(hearts, hp)
		yield(get_tree().create_timer(0.01), "timeout")
		shake_hearts(hp)
	else:
		# Health stayed same or increased (healing/respawn): stop tweens & reset
		tween.stop_all()
		_apply_base_colors(hearts, hp)

func _apply_base_colors(hearts: Array, hp: int):
	for i in range(hearts.size()):
		var heart = hearts[i]
		heart.rect_rotation = 0.0
		heart.rect_scale = Vector2(1, 1)
		# Full hearts white, empty hearts black
		heart.modulate = Color(1, 1, 1) if (i < hp) else Color(0, 0, 0)

func shake_hearts(current_hp: int):
	var hearts = [heart_1, heart_2, heart_3]
	var duration = 0.04
	var max_angle = 25.0
	var max_scale = Vector2(1.35, 1.35)
	
	tween.stop_all()
	
	for i in range(hearts.size()):
		var heart = hearts[i]
		
		# Skip empty/black hearts so they stay solid black on death
		if heart.modulate == Color(0, 0, 0):
			heart.rect_rotation = 0.0
			heart.rect_scale = Vector2(1, 1)
			continue
		
		heart.rect_pivot_offset = heart.rect_size / 2.0
		heart.rect_rotation = 0.0
		heart.rect_scale = Vector2(1, 1)
		
		# Red damage flash on active heart
		heart.modulate = Color(1.5, 0.3, 0.3)
		
		# 1. Scale pop
		tween.interpolate_property(
			heart, "rect_scale",
			Vector2(1, 1), max_scale,
			duration, Tween.TRANS_QUAD, Tween.EASE_OUT, 0
		)
		
		# 2. Rotational shake
		for step in 6:
			var target_rot = rand_range(-max_angle, max_angle)
			tween.interpolate_property(
				heart, "rect_rotation",
				heart.rect_rotation, target_rot,
				duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT,
				step * duration
			)
		
		# 3. Snap scale and rotation back
		tween.interpolate_property(
			heart, "rect_scale",
			max_scale, Vector2(1, 1),
			duration * 2, Tween.TRANS_QUAD, Tween.EASE_IN,
			4 * duration
		)
		tween.interpolate_property(
			heart, "rect_rotation",
			heart.rect_rotation, 0.0,
			duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT,
			6 * duration
		)
		
		# 4. Restore target color (White for active hearts)
		tween.interpolate_property(
			heart, "modulate",
			heart.modulate, Color(1, 1, 1),
			duration * 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,
			4 * duration
		)
		
	tween.start()
