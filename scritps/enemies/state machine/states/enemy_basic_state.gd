extends Node
class_name EnemyState



@export_category("References")
@export var enemy: Enemy

@onready var state_machine: EnemyStateMachine = %StateMachine



func _ready() -> void:
	if state_machine:
		enemy = state_machine.enemy
