extends RigidBody2D
class_name Player
### TODO:
# health, damage system
# moves left counter and system
# upgrades system (moves left, health, damage, bullet speed)
# ultra upgrades? - like auto rotate system or clamp the bullet to enemy
#



@export_category("Player Base Stats")
@export var stats: PlayerStats = preload("res://resources/player/default_player_stats.tres")
@export_category("References")
@export var shooting_marker: Marker2D
@export var hp_component: HPComponent
@export var UI: UserInterface
@export var interaction_area: Area2D
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




func _ready() -> void:
	Global.player = self
	Global.emit_signal("player_ready")
	set_gravity_scale(0.0)
	
	# coś się zepsuło
	if stats == null:
		print("but why null?")
		stats = PlayerStats.new()

func _process(delta: float) -> void:
	queue_redraw()

func _physics_process(delta: float) -> void:
	# recalculate normal of vector to mouse
	normal = (shooting_marker.global_position - global_position).normalized()
	
	# movement
	apply_movement()
	# rotation
	rotate_ship(delta)

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		# debug
		if Input.is_action_just_pressed("debug_toogle"):
			pass
		# dev exit game
		if Input.is_action_just_pressed("exit"):
			get_tree().quit()
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

func _draw() -> void:
	if Engine.is_editor_hint():
		return
	
	if(was_lmb_pressed):
		draw_line(Vector2.ZERO, get_local_mouse_position(), Color.CRIMSON, 2.0)
	if(rotate_to_mouse):
		draw_line(Vector2.ZERO, get_local_mouse_position(), Color.GREEN_YELLOW, 2.0)



## signal handlers
func _on_mouse_entered() -> void:
	is_mouse_inside = true

func _on_mouse_exited() -> void:
	is_mouse_inside = false



func shoot() -> void:
	var dir = (get_global_mouse_position() - global_position).normalized()
	var angle = normal.angle_to(dir)
	var bt: Bullet = bullet_scene.instantiate()
	
	# ograniczenie kąta strzału
	if abs(angle) > stats.shooting_angle:
		var bounded_angle = sign(angle) * stats.shooting_angle
		dir = normal.rotated(bounded_angle)
	
	# obrót pocisku żeby pasował do strzału
	bt.rotate(dir.angle() + PI/2)
	
	bt.direction = dir
	bt.global_position = shooting_marker.global_position
	get_tree().current_scene.add_child(bt)

func rotate_ship(delta: float) -> void:
	if rotate_to_mouse:
		var to_mouse_angle = (get_global_mouse_position() - global_position).angle()
		var angle_diff = wrapf(to_mouse_angle - rotation + PI/2, -PI, PI)
		var max_step = stats.rotate_speed * delta
		
		# clamp to max_step so it seems smooth?
		var rotate_step = clamp(angle_diff, -max_step, max_step)
		rotate(rotate_step)

func apply_movement() -> void:
	if shoot_force != Vector2.ZERO:
		apply_force(shoot_force * 50)
		shoot_force = Vector2.ZERO
