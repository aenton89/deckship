extends Components
class_name HPComponent
### TODO:
# analogicznie AttackComponent oraz HitboxComponent (czy na pewno potrzebne???)
# zamienić w damage amount: float na attack: AttackComponent
# youtube.com/watch?v=74y6zWZfQKk
#



signal player_died
signal player_took_dmg
signal player_healed

@onready var max_health: float
@onready var health: float

var parent: Node2D



func _ready() -> void:
	parent = get_parent().get_parent()



func init(amount: float) -> void:
	max_health = amount
	health = amount

func heal(amount: float) -> void:
	add_dmg_label(amount, Color.LIME_GREEN)
	health = clamp(health + amount, 0.0, max_health)
	
	
	if parent is Player:
		emit_signal("player_healed")

func damage(amount: float, is_crit: bool) -> void:
	if is_crit:
		add_dmg_label(amount, Color.DARK_RED)
	else:
		add_dmg_label(amount, Color.NAVAJO_WHITE)
	health = clamp(health - amount, 0.0, max_health)
	
	if parent is Player:
		emit_signal("player_took_dmg")
		if health <= 0:
			emit_signal("player_died")
	else:
		if health <= 0:
			parent.queue_free()

func add_dmg_label(amount: float, color: Color) -> void:
	# label od utraty hp
	var dmg_label = Label.new()
	dmg_label.text = "-" + str(amount)
	dmg_label.add_theme_font_size_override("font_size", 24)
	var body_size: Vector2 = Vector2(20, 30)
	
	# randomowe usytuowanie label'a
	for child in parent.get_children():
		if child is CollisionShape2D:
			body_size = child.shape.size
	dmg_label.global_position = parent.global_position - body_size + rand_label_range(body_size) 
	
	# kolor label'a 
	dmg_label.add_theme_color_override("font_color", color)
	
	# czas życia label'a
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(func(): dmg_label.queue_free())
	
	dmg_label.add_child(timer)
	get_tree().current_scene.add_child(dmg_label)

func rand_label_range(dimension: Vector2) -> Vector2:
	return Vector2(random_sign() * randi_range(dimension.x, dimension.x * 1.5), random_sign() * randi_range(dimension.y, dimension.y * 1.5))

func random_sign() -> int:
	return (randi() % 2) * 2 - 1
