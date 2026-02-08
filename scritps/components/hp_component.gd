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



func init(amount: float) -> void:
	max_health = amount
	health = amount

func heal(amount: float) -> void:
	add_component_label(amount, Color.LIME_GREEN)
	health = clamp(health + amount, 0.0, max_health)
	
	if parent is Player:
		emit_signal("player_healed")

func damage(amount: float, is_crit: bool) -> void:
	if is_crit:
		add_component_label(-amount, Color.DARK_RED)
	else:
		add_component_label(-amount, Color.NAVAJO_WHITE)
	health = clamp(health - amount, 0.0, max_health)
	
	if parent is Player:
		emit_signal("player_took_dmg")
		if health <= 0:
			emit_signal("player_died")
	else:
		if health <= 0:
			if parent.is_in_group("has_money"):
				Global.player.money_component.add_money(parent.money_component.money)
			parent.queue_free()

func add_component_label(amount: float, color: Color) -> void:
	# label od utraty hp
	var label: Label = Label.new()
	if amount >= 0:
		label.text = "+" + str(amount)
	else:
		label.text = str(amount)
	label.add_theme_font_size_override("font_size", 24)
	var body_size: Vector2 = Vector2(20, 30)
	
	# randomowe usytuowanie label'a
	for child in parent.get_children():
		if child is CollisionShape2D:
			body_size = child.shape.size
	label.global_position = parent.global_position - body_size + rand_label_range(body_size) 
	
	# kolor label'a 
	label.add_theme_color_override("font_color", color)
	
	# czas życia label'a
	var timer: Timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(func(): label.queue_free())
	
	label.add_child(timer)
	get_tree().current_scene.add_child(label)

func rand_label_range(dimension: Vector2) -> Vector2:
	return Vector2(random_sign() * randi_range(dimension.x, dimension.x * 1.5), random_sign() * randi_range(dimension.y, dimension.y * 1.5))

func random_sign() -> int:
	return (randi() % 2) * 2 - 1
