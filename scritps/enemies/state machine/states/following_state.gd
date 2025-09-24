extends EnemyState
class_name FollowingEnemyState



func _on_following_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		enemy.state_chart.send_event("on_idle")
