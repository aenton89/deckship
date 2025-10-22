extends EnemyState
class_name ShootingEnemyState



func _on_shooting_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		enemy.set_attacking_state(EnemyStateMachine.EnemyAtackingState.NOT_SHOOTING)
		enemy.state_chart.send_event("on_not_shooting")
