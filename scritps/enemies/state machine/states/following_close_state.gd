extends EnemyState
class_name FollowingCloseEnemyState



func _on_following_close_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.

func _on_move_away_area_body_exited(body: Node2D) -> void:
	if body is Player:
		enemy.state_chart.send_event("on_following_far")
