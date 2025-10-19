extends Node
class_name Components



var parent: Node2D



func _ready() -> void:
	parent = get_parent().get_parent()
