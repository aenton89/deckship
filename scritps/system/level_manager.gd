extends Node2D
class_name LevelManager



@export var curr_level: Level



func _ready() -> void:
	call_deferred("enter_level")



func enter_level() -> void:
	curr_level.on_level_entered()
