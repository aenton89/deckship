extends Node2D
class_name Level



signal level_entered
signal level_exited

@export var level_name: String = "LoremIpsum"
@export var next_level: PackedScene = preload("res://scenes/level/lvls/menu_level.tscn")
@export var spawn_point: SpawnPoint = null

@onready var enemies: Array[Node] = []



func enter_level() -> void:
	enemies = get_tree().get_nodes_in_group("enemies")
	
	level_entered.emit()

func exit_level() -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	enemies.clear()
	
	level_exited.emit()
