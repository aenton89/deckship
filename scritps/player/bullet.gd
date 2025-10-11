extends Area2D
class_name Bullet

### TODO: 
## zmienić, bo obrażenia są pobierane od gracza (dla wrogów też) a na dodatek jednorazowo xd, więc się nie aktualizują
# constructor that sets speed and dmg
# wciąż to co na górze - w _physics_process() jest brane Global.player.sats.bullet_speed
# no i jeszcze uwzględnić jakoś prędkość poruszającego się statku który strzela


@export_category("References")
@export var shape: CollisionShape2D
@export var sprite: Sprite2D
@export_category("Bullet Details")
# life time of bullet
@export var life_span: float = 3.0
@export var raycast_margin: float = 2.0

# specifies if bullet should bounce after collision
var bounce: int = 1
# specifies bullet statistics
var speed: float = 500.0
var dmg: float = 10.0
var dmg_amount: float
# direction vector
var direction: Vector2 = Vector2.ZERO
# time on earth (pray)
@onready var life_timer: Timer = %"Life Time"
@onready var is_crit: bool = false



func _ready() -> void:
	life_timer.one_shot = true
	life_timer.start(life_span)
	
	bounce = Global.player.stats.bounce_amount
	speed = Global.player.stats.bullet_speed
	dmg  = Global.player.stats.dmg

# na trafienie czegokolwiek (nawet siebie) zadać obrażenia; jeśli tamto coś nie zostanie zniszczone, to odbijamy pocisk (tylko 1 odbicie, nie więcej)
func _physics_process(delta: float) -> void:
	if Global.player:
		var motion = Global.player.stats.bullet_speed * direction * delta
		var space_state = get_world_2d().direct_space_state
		
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + motion.normalized() * (motion.length() + raycast_margin))
		 # ignorujemy pocisk
		query.exclude = [self]
		
		var result = space_state.intersect_ray(query)
		
		if result:
			var hit_body = result.collider
			apply_dmg(hit_body)
			
			if bounce > 0:
				var collision_normal = result.normal
				direction = direction.bounce(collision_normal).normalized()
				rotation = direction.angle() + PI / 2
				bounce -= 1
			else:
				queue_free()
		else:
			position += motion



# pocisk nie może istnieć w nieskończoność
func _on_life_timer_timeout() -> void:
	queue_free()



func apply_dmg(body: Node2D) -> void:
	is_crit = false
	dmg_amount = dmg
	
	var hp_component: HPComponent
	var components: Components
	
	for child in body.get_children():
		if child is Components:
			components = child
			break
	
	if components:
		for child in components.get_children():
			if child is HPComponent:
				hp_component = child
				break
		
		if hp_component:
			# apply crit
			if Global.player and randf() < Global.player.stats.crit_chance:
				dmg_amount = dmg * Global.player.stats.crit_amount
				is_crit = true
			
			hp_component.damage(dmg_amount, is_crit)
			
			#add_dmg_label(body, dmg_amount)
			
			# jeśli obiekt już został zniszczony
			if hp_component.health <= 0:
				# body.queue_free()
				queue_free()
				return

#func add_dmg_label(body: Node2D, amount: float) -> void:
	## label od utraty hp
	#var dmg_label = Label.new()
	#dmg_label.text = "-" + str(dmg_amount)
	#dmg_label.add_theme_font_size_override("font_size", 24)
	#var body_size: Vector2 = Vector2(20, 30)
	#
	## randomowe usytuowanie label'a
	#for child in body.get_children():
		#if child is CollisionShape2D:
			#body_size = child.shape.size
	#dmg_label.global_position = body.global_position - body_size + rand_label_range(body_size) 
	#
	## kolor label'a 
	#if crit_label:
		#dmg_label.add_theme_color_override("font_color", Color.DARK_RED)
	#
	## czas życia label'a
	#var timer = Timer.new()
	#timer.wait_time = 0.5
	#timer.one_shot = true
	#timer.autostart = true
	#timer.timeout.connect(func(): dmg_label.queue_free())
	#
	#dmg_label.add_child(timer)
	#get_tree().current_scene.add_child(dmg_label)
#
#func rand_label_range(dimension: Vector2) -> Vector2:
	#return Vector2(random_sign() * randi_range(dimension.x, dimension.x * 1.5), random_sign() * randi_range(dimension.y, dimension.y * 1.5))
#
#func random_sign() -> int:
	#return (randi() % 2) * 2 - 1
