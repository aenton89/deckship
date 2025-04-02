extends RigidBody2D
class_name ship

var bllt: PackedScene = preload("res://scenes/bullet.tscn")

@onready var is_mouse_inside: bool = false
@onready var was_lmb_pressed: bool = false

var shoot_force: Vector2 = Vector2.ZERO


func _ready() -> void:
	set_gravity_scale(0.0)

func _process(delta: float) -> void:
	queue_redraw()

func _physics_process(delta: float) -> void:
	if shoot_force != Vector2.ZERO:
		apply_force(shoot_force * 50)
		shoot_force = Vector2.ZERO


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


func _on_mouse_entered() -> void:
	is_mouse_inside = true
	#print("mouse entered")

func _on_mouse_exited() -> void:
	is_mouse_inside = false
	#print("mouse exited")

func shoot() -> void:
	var dir = (get_global_mouse_position() - global_position).normalized()
	var bt: bullet = bllt.instantiate()
	bt.direction = dir
	bt.global_position = global_position
	get_parent().add_child(bt)

func _draw() -> void:
	if(was_lmb_pressed):
		draw_line(Vector2.ZERO, get_local_mouse_position(), Color.CRIMSON, 2)
	else:
		pass
