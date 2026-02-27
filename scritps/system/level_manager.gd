extends Node2D
class_name LevelManager



# defaultowo menu
@export var starting_level: Level

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
	
	# gracz przesunięty na miejsce spawn point'u
	if curr_level.spawn_point:
		Global.player.global_position = curr_level.spawn_point.global_position

func on_level_exited() -> void:
	enter_new_level(curr_level.next_level.instantiate())
