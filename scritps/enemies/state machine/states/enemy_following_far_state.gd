extends EnemyState
class_name FollowingFarEnemyState



func _on_following_far_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.

func _on_perfect_area_body_entered(body: Node2D) -> void:
	if body is Player:
		enemy.set_movement_state(EnemyStateMachine.EnemyMovementState.FOLLOWING_MID)
		enemy.state_chart.send_event("on_following_mid")
