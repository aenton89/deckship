extends EnemyState
class_name ShootingRegularEnemyState



func _on_shooting_regular_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.

func _on_move_away_area_body_entered(body: Node2D) -> void:
	if body is Player:
		enemy.set_attacking_state(EnemyStateMachine.EnemyAtackingState.SHOOTING_CANVA)
		enemy.state_chart.send_event("on_shooting_canva")
