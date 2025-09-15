extends RigidBody2D
class_name Enemy
### TODO:
# obracanie się do gracza (ale też z określoną prędkością)
# strzelanie
#



@export_category("References")
@export var detection_area: Area2D
@export var detection_shape: CollisionShape2D
@export_category("Movement Stats")
@export_subgroup("Movement Defaults")
@export var detection_range: float = 500.0
@export var force_strength: float = 10.0
# w sekundach
@export var movement_cooldown: float = 1.0
# treshold poniżej którego enemy dolatuje prosto do położenia gracza, a nie końca jego wektora prędkości
@export var player_vel_treshold: float = 300.0
@export_subgroup("Moving Away")
@export var move_away_range: float = 150.0
@export var move_away_force_scaling: float = 0.1

@onready var is_following: bool = false
@onready var chase_force: Vector2 = Vector2.ZERO
# zmienne do śledzenia kierunku gracza
@onready var last_player_direction: Vector2 = Vector2.ZERO
@onready var last_force_time: float = 0.0

var target_point: Vector2



func _ready():
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	set_gravity_scale(0.0)
	
	if detection_shape and detection_shape.shape is CircleShape2D:
		detection_shape.shape.radius = detection_range

func _process(_delta):
	# wymusza odświeżenie rysunku w każdej klatce
	queue_redraw()

func _physics_process(delta):
	if is_following:
		apply_movement()
		calculate_chase_force()


func apply_movement() -> void:
	if chase_force != Vector2.ZERO:
		print("applied: ", chase_force)
		apply_force(chase_force)
		chase_force = Vector2.ZERO

func calculate_chase_force() -> void:
	if Global.player:
		run_away()
		chase()

func run_away() -> void:
	var distance_to_player = global_position.distance_to(Global.player.global_position)
	if distance_to_player < move_away_range:
		var direction_away = global_position - Global.player.global_position
		chase_force = direction_away * force_strength * move_away_force_scaling
		
		# aktualizuj zmienne czasowe i kierunek
		var current_time = Time.get_ticks_msec() / 1000.0
		var current_player_direction = Vector2.ZERO
		if Global.player.linear_velocity.length() > 0:
			current_player_direction = Global.player.linear_velocity.normalized()
		
		last_player_direction = current_player_direction
		last_force_time = current_time

func chase() -> void:
	# aktualny kierunek gracza (znormalizowany wektor prędkości)
	var current_player_direction = Vector2.ZERO
	if Global.player.linear_velocity.length() > 0:
		current_player_direction = Global.player.linear_velocity.normalized()
	
	# czy minęła sekunda od ostatniego przyłożenia siły
	var current_time = Time.get_ticks_msec() / 1000.0
	var time_passed = current_time - last_force_time >= movement_cooldown
	# czy kierunek gracza się zmienił
	var direction_changed = current_player_direction.distance_to(last_player_direction) > 0.1
	
	# aplikuj siłę jeśli kierunek się zmienił lub minęła sekunda
	if direction_changed or time_passed:
		# punkt docelowy na końcu wektora prędkości gracza
		if Global.player.linear_velocity.length() < player_vel_treshold:
			target_point = Global.player.global_position
		else:
			target_point = Global.player.global_position + Global.player.linear_velocity
		# kierunek do punktu docelowego - narazie nieznormalizowany w sumie
		var direction_to_target = target_point - global_position
		
		# ustawianie siły
		chase_force = direction_to_target * force_strength
		last_player_direction = current_player_direction
		last_force_time = current_time


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		is_following = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		is_following = false


func _draw():
	if Engine.is_editor_hint():
		return
	
	# okrąg reprezentujący zasięg wykrycia
	draw_circle(Vector2.ZERO, detection_range, Color.RED, false, 2.0)
	# okrąg reprezentujący zasięg, w którym uciekamy
	draw_circle(Vector2.ZERO, move_away_range, Color.GREEN, false, 2.0)
	
	# rysowanie linii do gracza
	if is_following:
		var distance = global_position.distance_to(Global.player.global_position)
		if distance <= detection_range:
			var local_player_pos = to_local(Global.player.global_position)
			draw_line(Vector2.ZERO, local_player_pos, Color.YELLOW, 2.0)
			
			# punkt docelowy - punkt, do którego chcemy się dostać
			var local_target = to_local(target_point)
			draw_circle(local_target, 5, Color.WHITE, true)
