extends Node2D
class_name Reward


@export_category("References")
@export var animated_sprite: AnimatedSprite2D
@export_category("Reward Stats")
@export var number_of_drops: int = 4
@export_category("Reward Chances")
@export var multi_chance: float = 0.3



func _ready() -> void:
	randomize()
	animated_sprite.play("idle")



func generate_from_preset(preset: Dictionary) -> Array[Bonus]:
	var result: Array[Bonus] = []
	for bonus_data in preset["bonuses"]:
		var b = Bonus.new(bonus_data["type"], bonus_data["value"])
		result.append(b)
	return result

func pick_random_preset() -> Dictionary:
	# losowanie czy bierzemy single czy multi
	var use_multi = randf()
	print(use_multi)
	if use_multi < multi_chance:
		return CardPresets.MULTI_BONUS_PRESETS[randi() % CardPresets.MULTI_BONUS_PRESETS.size()]
	else:
		return CardPresets.SINGLE_BONUS_PRESETS[randi() % CardPresets.SINGLE_BONUS_PRESETS.size()]



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var preset = pick_random_preset()
		Global.UI.hand_control.add_card(preset)
	
		# debug bonusów:
		for bonus_data in preset["bonuses"]:
			print("Bonus: ", Bonus.StatBoosts.keys()[bonus_data["type"]], " = ", bonus_data["value"])
	
		# animacja (tween w górę i powrót)
		var original_y = position.y
		var tween = create_tween()
		tween.tween_property(self, "position:y", position.y - 50, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position:y", original_y, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		
		number_of_drops -= 1
		# jeśli to był ostatni drop, usuń dopiero po skończeniu tweena
		if number_of_drops == 0:
			tween.finished.connect(func():
				queue_free()
			)
