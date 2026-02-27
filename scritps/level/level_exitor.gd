extends Node2D
class_name LevelExitor



var parent_lvl: Level



func _ready() -> void:
	call_deferred("get_lvl_parent")



func get_lvl_parent() -> void:
	var current = get_parent()
	
	while current != null:
		if current is Level:
			parent_lvl = current
			return
		
		current = current.get_parent()



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		parent_lvl.exit_level()
