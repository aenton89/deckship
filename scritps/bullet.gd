extends Area2D
class_name bullet

### TODO: 
# bouncing system - one bounce per bullet if the body it hit wasn't destroyed
# constructor that sets speed and dmg
#

### VARIABLES
## regular variables
# direction vector
var direction: Vector2 = Vector2.ZERO

## onready variables
# specifies if bullet should bounce after collision
@onready var bounce: bool = true
# specifies bullet statistics
@onready var speed: float = 500.0
@onready var dmg: float = 10.0 


### FUNCTIONS
func _physics_process(delta: float) -> void:
	position += speed * direction * delta

# na trafienie czegokolwiek (nawet siebie) zadać obrażenia
# jeśli tamto coś nie zostanie zniszczone, to odbijamy pocisk (tylko 1 odbicie, nie więcej
func _on_body_entered(body: Node2D) -> void:
	if body.get_parent().is_in_group("player") or body.is_in_group("player"):
		pass
	else:
		# na trafienie przeciwnika zadajemy mu dmg, 
		body.queue_free()
		queue_free()
