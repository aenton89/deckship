extends Node
class_name PlayerState



@export_category("References")
@export var player: Player

@onready var state_machine: PlayerStateMachine = %StateMachine



func _ready() -> void:
	if state_machine:
		player = state_machine.player
