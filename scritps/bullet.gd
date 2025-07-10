extends Area2D
class_name Bullet

### TODO: 
# constructor that sets speed and dmg
#

### VARIABLES
## regular variables
# direction vector
var direction: Vector2 = Vector2.ZERO

## onready variables
# specifies if bullet should bounce after collision
@onready var bounce: bool = true
# time on earth (pray)
@onready var life_timer: Timer = $"life time"

## export variables
# specifies bullet statistics
@export var speed: float = 500.0
@export var dmg: float = 10.0 
# life time of bullet
@export var life_span: float = 3.0



### FUNCTIONS
## premade function
func _ready() -> void:
	life_timer.one_shot = true
	life_timer.start(life_span)

func _physics_process(delta: float) -> void:
	position += speed * direction * delta


## signal handlers
# na trafienie czegokolwiek (nawet siebie) zadać obrażenia; jeśli tamto coś nie zostanie zniszczone, to odbijamy pocisk (tylko 1 odbicie, nie więcej)
func _on_body_entered(body: Node2D) -> void:
	var hp_component: HPComponent
	
	# ogarniamy HPComponent tego w co trafiliśmy
	for child in body.get_children():
		if child is HPComponent:
			hp_component = child
			break
	
	# zadajemy obrażenia
	if hp_component != null:
		hp_component.damage(dmg)
	
	# jeśli już zniszczyliśmy obiekt
	if hp_component.health <= 0:
		queue_free()
		return
	
	# jeśli 1. raz coś trafimy i trafiony obiekt przeżył
	if bounce:
		var collision_normal = (global_position - body.global_position).normalized()
		direction = direction.bounce(collision_normal)
		
		rotation = direction.angle() + PI/2
		
		bounce = false
	else:
		queue_free()

# pocisk nie może istnieć w nieskończoność
func _on_life_timer_timeout() -> void:
	queue_free()
