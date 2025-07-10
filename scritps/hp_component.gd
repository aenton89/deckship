extends Node
class_name HPComponent

### TODO:
# analogicznie AttackComponent oraz HitboxComponent (czy na pewno potrzebne???)
# zamienić w damage amount: float na attack: AttackComponent
# youtube.com/watch?v=74y6zWZfQKk
#

### VARIABLES
## export variables
@export var max_health: float = 100.0

## onready variables
@onready var health: float = max_health



### FUNCTIONS
## my functions
func damage(amount: float) -> void:
	health -= amount
	print("health: ", health)
	
	if health <= 0:
		get_parent().queue_free()
