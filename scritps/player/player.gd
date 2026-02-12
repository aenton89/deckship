extends RigidBody2D
class_name Player
### TODO:
# health, damage system
# moves left counter and system
# upgrades system (moves left, health, damage, bullet speed)
# ultra upgrades? - like auto rotate system or clamp the bullet to enemy
#



@export_category("Player Base Stats")
@export var stats: ShipStats = preload("res://resources/stats/player_stats.tres")
@export_category("References")
@export var camera_rig: CameraRig
@export var shooting_marker: Marker2D
@export var UI: UserInterface
@export var interaction_area: Area2D
@export var dodge_timer: Timer
@export var sprite: Sprite2D
@export var braking_sprite: Sprite2D
@export_subgroup("Components")
@export var hp_component: HPComponent
@export var money_component: MoneyComponent
@export_category("Imports")
@export var bullet_scene: PackedScene = preload("res://scenes/player/bullet.tscn")

# normal vector - ship's facing direction
@onready var normal: Vector2 = Vector2.ZERO
# user input
@onready var is_mouse_inside: bool = false
@onready var was_lmb_pressed: bool = false
@onready var rotate_to_mouse: bool = false
# shooting vars
@onready var shoot_force: Vector2 = Vector2.ZERO
# dodge cooldown
@onready var dodges_available: int = stats.dodge_amount



func _ready() -> void:
	Global.player = self
	set_gravity_scale(0.0)
	
	# coś się zepsuło
	if stats == null:
		if Global.draw_debug:
			print("but why null?")
		stats = ShipStats.new()
	
	hp_component.init(stats.max_hp)
	hp_component.player_took_dmg.connect(_on_took_dmg)
	
	dodge_timer.one_shot = true
	dodge_timer.autostart = false
	dodge_timer.timeout.connect(_on_dodge_cooldown)
	
	Global.emit_signal("player_ready")

func _process(delta: float) -> void:
	queue_redraw()

func _physics_process(delta: float) -> void:
	# recalculate normal of vector to mouse
	normal = (shooting_marker.global_position - global_position).normalized()
	
	# movement
	apply_movement()
	# rotation
	rotate_ship(delta)
	# braking
	apply_brake(delta)

func _input(event: InputEvent) -> void:
	# begin movement or shoot
	if Input.is_action_just_pressed("shoot_and_move") and !Input.is_action_pressed("cards_interactions"):
		# movement direction
		if is_mouse_inside:
			was_lmb_pressed = true
		# shooting
		else:
			shoot()
	# apply movement force
	if Input.is_action_just_released("shoot_and_move") and !Input.is_action_pressed("cards_interactions"):
		if was_lmb_pressed:
			shoot_force = global_position - get_global_mouse_position()
			was_lmb_pressed = false
	# rotation
	if Input.is_action_just_pressed("rotate"):
		rotate_to_mouse = true
	if Input.is_action_just_released("rotate"):
		rotate_to_mouse = false
	# dodging
	if Input.is_action_just_pressed("dodge_left"):
		dodge(Vector2.LEFT)
	if Input.is_action_just_pressed("dodge_right"):
		dodge(Vector2.RIGHT)
	if Input.is_action_just_pressed("dodge_up"):
		dodge(Vector2.UP)
	if Input.is_action_just_pressed("dodge_down"):
		dodge(Vector2.DOWN)



## signal handlers
func _on_mouse_entered() -> void:
	is_mouse_inside = true

func _on_mouse_exited() -> void:
	is_mouse_inside = false

func _on_took_dmg() -> void:
	camera_rig.shake_camera()

func _on_dodge_cooldown() -> void:
	dodges_available += 1
	Global.UI.hud.dodge_ui.add_bars(1)
	
	if dodges_available < stats.dodge_amount:
		dodge_timer.start(stats.dodge_cooldown)
		Global.UI.hud.dodge_ui.start_cooldown()



func shoot() -> void:
	var dir: Vector2 = (get_global_mouse_position() - global_position).normalized()
	var angle: float = normal.angle_to(dir)
	
	# ograniczenie kąta strzału
	if abs(angle) > stats.shooting_angle:
		var bounded_angle: float = sign(angle) * stats.shooting_angle
		dir = normal.rotated(bounded_angle)
	
	var bt: Bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bt)
	bt.init(
		dir,
		shooting_marker.global_position,
		null,
		Vector2(1.5, 1.5),
		stats.bullet_speed,
		stats.dmg,
		stats.bounce_amount,
		stats.bullet_explosion_force
	)

func rotate_ship(delta: float) -> void:
	if rotate_to_mouse:
		var to_mouse_angle: float = (get_global_mouse_position() - global_position).angle()
		var angle_diff: float = wrapf(to_mouse_angle - rotation + PI/2, -PI, PI)
		var max_step: float = stats.rotate_speed * delta
		
		# clamp to max_step so it seems smooth?
		var rotate_step: float = clamp(angle_diff, -max_step, max_step)
		rotate(rotate_step)

func apply_movement() -> void:
	if shoot_force != Vector2.ZERO:
		if Global.draw_debug:
			print("PLAYER applied force: ", shoot_force * 20)
		apply_force(shoot_force * 20)
		shoot_force = Vector2.ZERO

func dodge(direction: Vector2) -> void:
	if dodges_available > 0:
		var dodge_vector: Vector2 = direction.rotated(rotation) * stats.dodge_strength
		apply_impulse(dodge_vector)
		
		for i in range(3):
			spawn_ghost_trail()
			await get_tree().create_timer(0.1).timeout
		
		dodges_available -= 1
		Global.UI.hud.dodge_ui.remove_bars(1)
		dodge_timer.start(stats.dodge_cooldown)
		Global.UI.hud.dodge_ui.start_cooldown()

func spawn_ghost_trail():
	var ghost: Sprite2D = Sprite2D.new()
	ghost.texture = sprite.texture
	ghost.global_position = sprite.global_position
	ghost.global_rotation = sprite.global_rotation
	ghost.scale = sprite.scale
	
	get_tree().current_scene.add_child(ghost)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, 0.25)
	tween.tween_callback(ghost.queue_free)

func apply_brake(delta: float) -> void:
	if Input.is_action_pressed("brake"):
		linear_velocity = linear_velocity.move_toward(Vector2.ZERO, stats.braking_strength * delta)
		braking_sprite.visible = true
	else:
		braking_sprite.visible = false


func _draw() -> void:
	if Global.draw_debug:
		if Engine.is_editor_hint():
			return
		
		if(was_lmb_pressed):
			draw_line(Vector2.ZERO, get_local_mouse_position(), Color.CRIMSON, 2.0)
		if(rotate_to_mouse):
			draw_line(Vector2.ZERO, get_local_mouse_position(), Color.GREEN_YELLOW, 2.0)
