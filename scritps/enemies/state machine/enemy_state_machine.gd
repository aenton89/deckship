extends Node
class_name EnemyStateMachine



enum EnemyMovementState {IDLE, FOLLOWING_FAR, FOLLOWING_MID, MOVING_AWAY}
enum EnemyAtackingState {NOT_SHOOTING, SHOOTING_REGULAR, SHOOTING_CANVA}

@export_category("References")
@export var enemy: Enemy
