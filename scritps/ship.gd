extends RigidBody2D
class_name Ship

### TODO:
# health, damage system
# moves left counter and system
# upgrades system (moves left, health, damage, bullet speed)
# ultra upgrades? - like auto rotate system or clamp the bullet to enemy
#

### VARIABLES
## regular variables
# bullet scene
var bllt: PackedScene = preload("res://scenes/bullet.tscn")
# normal vector - ship's facing direction
var normal: Vector2 = Vector2.ZERO

## onready variables
# ship's nodes
@onready var marker: Marker2D = $"shooting marker"
# user input
@onready var is_mouse_inside: bool = false
@onready var was_lmb_pressed: bool = false
@onready var rotate_to_mouse: bool = false
# shooting vars
@onready var shoot_force: Vector2 = Vector2.ZERO

## export variables
# shooting vars
@export var shooting_angle: float = PI/4
# rotation vars
@export var rotate_speed: float = 5.0
# hp component
@export var hp: HPComponent


### FUNCTIONS
## premade functions
func _ready() -> void:
	set_gravity_scale(0.0)

func _process(delta: float) -> void:
	queue_redraw()

func _physics_process(delta: float) -> void:
	normal = (marker.global_position - global_position).normalized()
	
	if shoot_force != Vector2.ZERO:
		apply_force(shoot_force * 50)
		shoot_force = Vector2.ZERO
	
	if rotate_to_mouse:
		var to_mouse_angle = (get_global_mouse_position() - global_position).angle()
		var angle_diff = wrapf(to_mouse_angle - rotation + PI/2, -PI, PI)
		var max_step = rotate_speed * delta
		
		# clamp to max_step so it seems smooth?
		var rotate_step = clamp(angle_diff, -max_step, max_step)
		rotate(rotate_step)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and is_mouse_inside:
				print("point it")
				was_lmb_pressed = true
			elif not event.pressed and was_lmb_pressed:
				shoot_force = global_position - get_global_mouse_position()
				
				print("and shoot it: ", shoot_force)
				was_lmb_pressed = false
			elif event.pressed and not is_mouse_inside:
				print("fire!")
				shoot()
		
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				print("start rotating...")
				rotate_to_mouse = true
			else: 
				print("stop rotating!")
				rotate_to_mouse = false


## signal handlers
func _on_mouse_entered() -> void:
	is_mouse_inside = true

func _on_mouse_exited() -> void:
	is_mouse_inside = false


## my functions
func shoot() -> void:
	var dir = (get_global_mouse_position() - global_position).normalized()
	var angle = normal.angle_to(dir)
	var bt: Bullet = bllt.instantiate()
	
	# ograniczenie kąta strzału
	if abs(angle) > shooting_angle:
		var bounded_angle = sign(angle) * shooting_angle
		dir = normal.rotated(bounded_angle)
	
	# obrót pocisku żeby pasował do strzału
	bt.rotate(dir.angle() + PI/2)
	
	bt.direction = dir
	bt.global_position = marker.global_position
	get_tree().current_scene.add_child(bt)


## TODO: coś nie tak z tym draw_arc()
func _draw() -> void:
	#var center = to_local(global_position)
	#var start_angle = normal.rotated(-PI/4).angle()
	#var end_angle = normal.rotated(PI/4).angle()
	#
	#draw_arc(center, 90, start_angle, end_angle, 32, Color.BLUE_VIOLET, 2.0)
	#draw_line(to_local(marker.global_position), to_local(global_position), Color.DARK_OLIVE_GREEN, 50.0)
	
	if(was_lmb_pressed):
		draw_line(Vector2.ZERO, get_local_mouse_position(), Color.CRIMSON, 2.0)
	if(rotate_to_mouse):
		draw_line(Vector2.ZERO, get_local_mouse_position(), Color.GREEN_YELLOW, 2.0)
