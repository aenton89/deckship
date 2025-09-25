extends RigidBody2D
class_name Enemy
### TODO:
## obracanie się do gracza (ale też z określoną prędkością)
## dodać dodatkowy obszar, w którym przeciwnik się nie rusza - ten w którym stara się utrzymać
# firing - kanwa gdy gracz jest za blisko, 
# move_away - przykładamy siłe przeciwną do gracza
# 


@export_category("References")
@export var detection_area: Area2D
@export var move_away_area: Area2D
@export var detection_shape: CollisionShape2D
@export var move_away_shape: CollisionShape2D
@export var perfect_distance_shape: CollisionShape2D
@export var shooting_marker: Marker2D
@export var state_chart: StateChart
@export_category("Imports")
@export var bullet_scene: PackedScene = preload("res://scenes/player/bullet.tscn")
@export var bullet_icon: CompressedTexture2D = preload("res://assets/enemies/bullet_enemy.png")

@export_category("Movement Stats")
@export_subgroup("Movement Defaults")
# bo normalnie by było lekko za wolno
@export var force_multiplier: float = 10.0
# w sekundach
@export var movement_cooldown: float = 1.0
# treshold poniżej którego enemy dolatuje prosto do położenia gracza, a nie końca jego wektora prędkości
@export var player_vel_treshold: float = 30.0
# radiany/sekunde
@export var max_angular_speed: float = 1.0

@export_subgroup("Following Far")
@export var detection_range: float = 1000.0
@export var max_speed_following_far: float = 8000.0
@export_subgroup("Perfect Distance")
@export var perfect_range: float = 600.0
@export var max_speed_following_mid: float = 4000.0
@export_subgroup("Moving Away")
@export var move_away_range: float = 300.0
@export var max_speed_moving_away: float = 2000.0

@export_category("Shooting Stats")
@export_subgroup("Shooting Defaults")
@export var shooting_cooldown: float = 2.0
@export var shooting_angle: float = PI / 4
@export_subgroup("Move Away Firing")
@export var firing_cooldown: float = 0.1
@export var firing_amount: int = 5

# stan z maszyny stanów
@onready var attacking_state: EnemyStateMachine.EnemyAtackingState = EnemyStateMachine.EnemyAtackingState.NOT_SHOOTING
@onready var movement_state: EnemyStateMachine.EnemyMovementState = EnemyStateMachine.EnemyMovementState.IDLE

# zwiaszane z ruchem
@onready var max_speed: float = max_speed_following_far
@onready var movement_force: Vector2 = Vector2.ZERO
@onready var can_move_on_own: bool = false

# zmienne do śledzenia kierunku gracza
@onready var last_player_direction: Vector2 = Vector2.ZERO
@onready var shooting_timer: Timer = Timer.new()
@onready var movement_timer: Timer = Timer.new()
@onready var firing_timer: Timer = Timer.new()
@onready var firing_counter: int = 0

var target_point: Vector2



func _ready() -> void:
	set_gravity_scale(0.0)
	
	if detection_shape and detection_shape.shape is CircleShape2D:
		detection_shape.shape.radius = detection_range
	if move_away_shape and move_away_shape.shape is CircleShape2D:
		move_away_shape.shape.radius = move_away_range
	if perfect_distance_shape and perfect_distance_shape.shape is CircleShape2D:
		perfect_distance_shape.shape.radius = perfect_range
	
	shooting_timer.wait_time = shooting_cooldown
	shooting_timer.autostart = false
	shooting_timer.one_shot = true
	shooting_timer.timeout.connect(_on_shooting_timer_timeout)
	add_child(shooting_timer)
	
	movement_timer.wait_time = movement_cooldown
	movement_timer.autostart = false
	movement_timer.one_shot = true
	movement_timer.timeout.connect(_on_movement_timer_timeout)
	add_child(movement_timer)
	
	firing_timer.wait_time = firing_cooldown
	firing_timer.autostart = false
	firing_timer.one_shot = true
	firing_timer.timeout.connect(_on_firing_timer_timeout)
	add_child(firing_timer)

func _process(delta: float) -> void:
	# wymusza odświeżenie rysunku w każdej klatce
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not Global.player: 
		return
	
	apply_movement(delta)
	
	# dodatkowo obracanie do gracza, jeśli go widzimy
	if movement_state != EnemyStateMachine.EnemyMovementState.IDLE:
		rotate_towards_player(delta) 



func set_attacking_state(state: EnemyStateMachine.EnemyAtackingState) -> void:
	attacking_state = state
	
	if attacking_state == EnemyStateMachine.EnemyAtackingState.SHOOTING_REGULAR:
		shooting_timer.start()
	elif attacking_state == EnemyStateMachine.EnemyAtackingState.SHOOTING_CANVA:
		firing_counter = 0
		firing_timer.start()

func set_movement_state(state: EnemyStateMachine.EnemyMovementState) -> void:
	movement_state = state



func rotate_towards_player(delta: float) -> void:
	var current_angle = rotation
	var desired_angle = (Global.player.global_position - global_position).angle()
	
	# offset o 90 stopni, bo sprite ma przód na osi Y zamiast X
	desired_angle += PI/2
	
	# różnica kątów znormalizowana do przedziału [-PI, PI]
	var angle_diff = wrapf(desired_angle - current_angle, -PI, PI)
	# ogranicz prędkość obrotu
	var max_step = max_angular_speed * delta
	var angle_step = clamp(angle_diff, -max_step, max_step)
	
	rotation += angle_step

func apply_movement(delta: float) -> void:
	if movement_state == EnemyStateMachine.EnemyMovementState.FOLLOWING_FAR:
		max_speed = max_speed_following_far
		chase()
	if movement_state == EnemyStateMachine.EnemyMovementState.FOLLOWING_MID:
		max_speed = max_speed_following_mid
		chase()
	if movement_state == EnemyStateMachine.EnemyMovementState.MOVING_AWAY:
		max_speed = max_speed_moving_away
		move_away()
	
	# clamp do maksymalnej predkości
	if movement_force != Vector2.ZERO:
		movement_force = movement_force * force_multiplier
		movement_force = movement_force.clampf(-max_speed, max_speed)
		print("ENEMY applied force: ", movement_force)
		apply_force(movement_force)
		movement_force = Vector2.ZERO

func move_away() -> void:
	var direction_away = global_position - Global.player.global_position
	movement_force = direction_away
	
	# aktualizuj kierunek
	var current_player_direction = Vector2.ZERO
	if Global.player.linear_velocity.length() > 0:
		current_player_direction = Global.player.linear_velocity.normalized()
	last_player_direction = current_player_direction
	
	# reset dla timer'a
	can_move_on_own = false
	movement_timer.start()

func chase() -> void:
	# aktualny kierunek gracza (znormalizowany wektor prędkości)
	var current_player_direction = Vector2.ZERO
	if Global.player.linear_velocity.length() > 0:
		current_player_direction = Global.player.linear_velocity.normalized()
	
	# czy kierunek gracza się zmienił
	var direction_changed = current_player_direction.distance_to(last_player_direction) > 0.1
	# aktualizacja ostatniego kierunku
	last_player_direction = current_player_direction
	
	# aplikuj siłę jeśli kierunek się zmienił lub minęła sekunda
	if direction_changed or can_move_on_own:
		# punkt docelowy na końcu wektora prędkości gracza
		if Global.player.linear_velocity.length() < player_vel_treshold:
			target_point = Global.player.global_position
		else:
			target_point = Global.player.global_position + Global.player.linear_velocity
		# kierunek do punktu docelowego - narazie nieznormalizowany w sumie
		var direction_to_target = target_point - global_position
		
		# ustawianie siły
		movement_force = direction_to_target
		# reset dla timer'a
		can_move_on_own = false
		movement_timer.start()



func shoot() -> void:
	if not Global.player or not bullet_scene or not shooting_marker:
		return
	
	var dir = (Global.player.global_position - global_position).normalized()
	var forward = (shooting_marker.global_position - global_position).normalized()
	var angle = forward.angle_to(dir)
	
	# ograniczenie kąta strzału
	if abs(angle) > shooting_angle:
		var bounded_angle = sign(angle) * shooting_angle
		dir = forward.rotated(bounded_angle)
	
	var bt: Bullet = bullet_scene.instantiate()
	bt.sprite.texture = bullet_icon
	bt.sprite.scale = Vector2(1.5, 1.5)
	bt.global_position = shooting_marker.global_position
	bt.direction = dir
	bt.rotate(dir.angle() + PI/2)
	get_tree().current_scene.add_child(bt)
	
	shooting_timer.start()



func _on_shooting_timer_timeout() -> void:
	if attacking_state == EnemyStateMachine.EnemyAtackingState.SHOOTING_REGULAR:
		shooting_timer.start()
		shoot()

func _on_firing_timer_timeout() -> void:
	if attacking_state == EnemyStateMachine.EnemyAtackingState.SHOOTING_CANVA:
		if firing_counter < firing_amount:
			firing_counter += 1
			shoot()
			firing_timer.start()

func _on_movement_timer_timeout() -> void:
	can_move_on_own = true



func _draw():
	if Engine.is_editor_hint():
		return
	
	# okrąg reprezentujący zasięg wykrycia
	draw_circle(Vector2.ZERO, detection_range, Color.RED, false, 2.0)
	# okrąg reprezentujący idealny zasięg
	draw_circle(Vector2.ZERO, perfect_range, Color.YELLOW, false, 2.0)
	# okrąg reprezentujący zasięg, w którym uciekamy
	draw_circle(Vector2.ZERO, move_away_range, Color.GREEN, false, 2.0)
	
	# rysowanie linii do gracza
	if movement_state == EnemyStateMachine.EnemyMovementState.FOLLOWING_FAR or movement_state == EnemyStateMachine.EnemyMovementState.FOLLOWING_MID:
		var distance = global_position.distance_to(Global.player.global_position)
		if distance <= detection_range:
			var local_player_pos = to_local(Global.player.global_position)
			draw_line(Vector2.ZERO, local_player_pos, Color.YELLOW, 2.0)
			
			# punkt docelowy - punkt, do którego chcemy się dostać
			var local_target = to_local(target_point)
			draw_circle(local_target, 5, Color.WHITE, true)
