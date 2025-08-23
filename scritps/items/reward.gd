extends Node2D
class_name Reward


@export_category("References")
@export var animated_sprite: AnimatedSprite2D
@export_category("Bonus Variables")
@export var bonuses_per_card: int = 1



func _ready() -> void:
	animated_sprite.play("idle")



func generate_random_bonus() -> Bonus:
	var stats_values = Bonus.StatBoosts.values()
	var random_stat = stats_values[randi() % stats_values.size()]
	var random_value = randf_range(5, 50)
	
	print("bonus type: ", Bonus.StatBoosts.keys()[random_stat], ", value: ", random_value)
	return Bonus.new(random_stat, random_value)



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var bonuses: Array[Bonus] = []
		for i in range(bonuses_per_card):
			bonuses.append(generate_random_bonus())
		Global.UI.hand_control.add_card(bonuses)
		
		# zapamiętujemy oryginalną pozycję
		var original_y = position.y
		
		# tween w górę i powrót
		var tween = create_tween()
		tween.tween_property(self, "position:y", position.y - 50, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position:y", original_y, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
