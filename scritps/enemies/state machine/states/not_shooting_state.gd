extends EnemyState
class_name NotShootingEnemyState



func _on_not_shooting_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		enemy.state_chart.send_event("on_shooting")
