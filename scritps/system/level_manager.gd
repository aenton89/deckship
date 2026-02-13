extends Node2D
class_name LevelManager



# defaultowo menu, więc po to first_level jeszcze
@export var starting_level: Level
# potem będą ponumerowane, więc będzie łatwo przechodzić pomiędzy
@export var first_level: PackedScene = preload("res://scenes/levels/merchant_level.tscn")

var curr_level: Level


func _ready() -> void:
	Global.lvl_manager = self
	call_deferred("enter_new_level", starting_level)



func enter_new_level(new_level: Level) -> void:
	if curr_level:
		curr_level.queue_free()
	
	curr_level = new_level
	add_child(curr_level)
	
	curr_level.level_exited.connect(on_level_exited)
	curr_level.enter_level()

func on_level_exited() -> void:
	if curr_level.level_name == "MenuLevel":
		enter_new_level(first_level.instantiate())
