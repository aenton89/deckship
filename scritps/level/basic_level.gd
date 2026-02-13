extends Node2D
class_name Level



signal level_entered
signal level_exited

@export var level_name: String = ""



func enter_level() -> void:
	level_entered.emit()

func exit_level() -> void:
	level_exited.emit()
