extends Area2D
class_name Bullet
### TODO: 
## czy dodawać prędkość statku do prędkości pocisku???
# constructor that sets speed and dmg
# wciąż to co na górze - w _physics_process() jest brane Global.player.sats.bullet_speed
# no i jeszcze uwzględnić jakoś prędkość poruszającego się statku który strzela



@export_category("References")
@export var shape: CollisionShape2D
@export var sprite: Sprite2D
@export var life_timer: Timer
@export_category("Bullet Details")
# life time of bullet
@export var life_span: float = 3.0
@export var raycast_margin: float = 2.0

# specifies if bullet should bounce after collision
var bounce: int = 1
# specifies bullet statistics
var speed: float = 500.0
var dmg: float = 10.0
var crit_chance: float = 0.1
var crit_amount: float = 1.2
var dmg_amount: float
var explosion_force: float = 400.0
# direction vector
var dir: Vector2 = Vector2.ZERO

@onready var is_crit: bool = false



# na trafienie czegokolwiek (nawet siebie) zadać obrażenia; jeśli tamto coś nie zostanie zniszczone, to odbijamy pocisk (tylko 1 odbicie, nie więcej)
func _physics_process(delta: float) -> void:
	if Global.player:
		var motion: Vector2 = speed * dir * delta
		var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + motion.normalized() * (motion.length() + raycast_margin))
		 # ignorujemy pocisk
		query.exclude = [self]
		
		var result: Dictionary = space_state.intersect_ray(query)
		
		if result:
			var hit_body = result.collider
			hit_target(hit_body)
			
			if bounce > 0:
				var collision_normal = result.normal
				dir = dir.bounce(collision_normal).normalized()
				rotation = dir.angle() + PI / 2
				bounce -= 1
			else:
				queue_free()
		else:
			position += motion



func init(direction: Vector2, position: Vector2, texture: Texture2D = null, scale: Vector2 = Vector2.ONE, velocity: float = -1, damage: float = -1, bounce_amount: int = -1, critical_chance: float = -1, critical_amount: float = -1, force_of_explosion: float = -1) -> void:
	dir = direction.normalized()
	global_position = position
	
	if texture:
		sprite.texture = texture
	sprite.scale = scale
	
	if velocity >= 0:
		speed = velocity
	if damage >= 0:
		dmg = damage
	if bounce_amount >= 0:
		bounce = bounce_amount
	if critical_chance >= 0:
		crit_chance = critical_chance
	if critical_amount >= 0:
		crit_amount = critical_amount
	if force_of_explosion >= 0:
		explosion_force = force_of_explosion
	
	rotation = direction.angle() + PI/2
	life_timer.one_shot = true
	life_timer.start(life_span)


func hit_target(body: Node2D) -> void:
	var hp_component: HPComponent
	var component: Components
	
	for child in body.get_children():
		if child is Components:
			component = child
			break
	
	if component:
		for child in component.get_children():
			if child is HPComponent:
				hp_component = child
				break
		
		if hp_component:
			# zadaj obrażenia
			apply_dmg(body, hp_component)
			
			# jeśli obiekt już został zniszczony
			if hp_component.health <= 0:
				# body.queue_free()
				queue_free()
				return
			
			# jeśli nie został to jeszcze odbij
			apply_explosion_force(body)

func apply_dmg(body: Node2D, hp_component: HPComponent) -> void:
	is_crit = false
	dmg_amount = dmg
	
	# apply crit
	if Global.player and randf() < crit_chance:
		dmg_amount = dmg * crit_amount
		is_crit = true
	
	hp_component.damage(dmg_amount, is_crit)

func apply_explosion_force(body: Node2D) -> void:
	if body is RigidBody2D:
		var dir_from_bullet: Vector2 = (body.global_position - global_position).normalized()
		body.apply_impulse(dir_from_bullet * explosion_force)



# pocisk nie może istnieć w nieskończoność
func _on_life_timer_timeout() -> void:
	queue_free()
