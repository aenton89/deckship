extends EnemyState
class_name FollowingMidEnemyState



func _on_following_mid_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.

func _on_move_away_area_body_entered(body: Node2D) -> void:
	if body is Player:
		enemy.set_movement_state(EnemyStateMachine.EnemyMovementState.MOVING_AWAY)
		enemy.state_chart.send_event("on_following_close")

func _on_perfect_area_body_exited(body: Node2D) -> void:
	if body is Player:
		enemy.set_movement_state(EnemyStateMachine.EnemyMovementState.FOLLOWING_FAR)
		enemy.state_chart.send_event("on_following_far")
