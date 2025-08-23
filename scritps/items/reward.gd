extends Node2D
class_name Reward


@export var bonuses_per_card: int = 1



func _on_area_entered(area: Area2D) -> void:
	var bonuses: Array[Bonus] = []
	for i in range(bonuses_per_card):
		bonuses.append(generate_random_bonus())
	Global.UI.hand_control.add_card(bonuses)



func generate_random_bonus() -> Bonus:
	var stats_values = Bonus.StatBoosts.values()
	var random_stat = stats_values[randi() % stats_values.size()]
	var random_value = randf_range(5, 50)
	
	print("bonus type: ", Bonus.StatBoosts.keys()[random_stat], ", value: ", random_value)
	return Bonus.new(random_stat, random_value)
