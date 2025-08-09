extends RigidBody2D
class_name Rock

### TODO:
# random spawning of rocks
# randomized if they move or not, direction of movement, rotation
#



@export_category("Rock Details")
@export var hp: float = 20.0
@export_category("References")
@export var hp_component: HPComponent



func _ready() -> void:
	set_gravity_scale(0.0)
	hp_component.max_health = hp
	hp_component.health = hp
