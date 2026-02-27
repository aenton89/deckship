extends Node2D
class_name Level



signal level_entered
signal level_exited

@export var level_name: String = "LoremIpsum"
@export var next_level: PackedScene = preload("res://scenes/level/lvls/menu_level.tscn")
@export var spawn_point: SpawnPoint = null



func enter_level() -> void:
	level_entered.emit()

func exit_level() -> void:
	level_exited.emit()
