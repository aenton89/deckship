extends EnemyState
class_name IdleEnemyState



func _on_idle_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		enemy.set_movement_state(EnemyStateMachine.EnemyMovementState.FOLLOWING_FAR)
		enemy.state_chart.send_event("on_following")
