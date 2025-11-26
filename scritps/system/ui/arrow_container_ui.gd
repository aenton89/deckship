extends Control
class_name ArrowContainer
### TODO: 
## przepisać to na lepszy pomysł detekcji wrogów niż detection_range = 2000.0
## w UI jest przypisanie tylko w ready wszystkich wrogów - to też zmienić na dodawanie sie przez wrogów automatycznie
## przenieść też obliczanie screen_size, screen_rect oraz screen_center na jednorazowe a nie co klatke
## w sumie to te obrażenia zadawane wrogom zza ekranu też można umieszczać na krawędzi ekranu jeśli sa poza nim



@export_category("Imports")
@export var arrow_scene: PackedScene = preload("res://scenes/system/ui/enemy_arrow.tscn")
@export_category("Detection")
@export var detection_range: float = 4000.0

@onready var enemies: Array[Node] = []
@onready var arrows = {}

var screen_size: Vector2
var screen_rect: Rect2
var screen_center: Vector2



func _ready() -> void:
	screen_size = get_viewport_rect().size
	screen_rect = Rect2(Vector2.ZERO, screen_size)
	screen_center = screen_size / 2.0

func _process(_delta: float) -> void:
	if !Global.player or !Global.camera:
		return
	
	var visible_rect: Rect2 = Rect2(Vector2.ZERO, screen_size)
	
	for enemy in enemies.duplicate():
		if !is_instance_valid(enemy):
			if arrows.has(enemy):
				arrows[enemy].queue_free()
				arrows.erase(enemy)
			enemies.erase(enemy)
			continue
		
		var to_enemy: Vector2 = enemy.global_position - Global.player.global_position
		var dist: float = to_enemy.length()
		
		# za daleko, usuń strzałkę
		if dist > detection_range:
			remove_arrow(enemy)
			continue
		
		# pozycja wroga na ekranie
		var screen_pos: Vector2 = world_to_screen(enemy.global_position)
		
		if visible_rect.has_point(screen_pos):
			# wróg jest na ekranie - usuń strzałkę
			remove_arrow(enemy)
			continue
		
		# poza ekranem - pokaż strzałkę
		var arrow: Node2D = get_or_create_arrow(enemy)
		# wektor od środka ekranu do pozycji wroga
		var dir: Vector2 = (screen_pos - screen_center).normalized()
		# ustaw pozycję na krawędzi ekranu w kierunku dir
		arrow.position = get_point_on_screen_edge(dir, screen_size)
		# obróć grot w kierunku od środka ekranu (czyli wektor dir)
		arrow.rotation = dir.angle() + PI/2



# przelicza pozycję świata na ekran (uwzględnia przesunięcie i zoom kamery)
func world_to_screen(world_pos: Vector2) -> Vector2:
	var viewport_size: Vector2 = get_viewport_rect().size
	var cam_pos: Vector2 = Global.camera.global_position
	var zoom: float = Global.camera.zoom.x
	
	# relatywna pozycja do kamery w świecie
	var relative_pos: Vector2 = world_pos - cam_pos
	# przeliczenie na piksele ekranu (zoom działa jako skala)
	var screen_pos: Vector2 = relative_pos * zoom + viewport_size * 0.5
	
	return screen_pos

# ustawia punkt na krawędzi ekranu w kierunku dir (od środka)
func get_point_on_screen_edge(dir: Vector2, screen_size: Vector2) -> Vector2:
	var half: Vector2 = screen_size / 2.0
	var k: float = half.y / abs(dir.y)
	if abs(dir.x) * k > half.x:
		k = half.x / abs(dir.x)
	
	# 0.95, żeby nie wychodziła poza ekran
	var edge_pos: Vector2 = half + dir * k * 0.95
	
	return edge_pos

func get_or_create_arrow(enemy: Node2D) -> Node2D:
	if !arrows.has(enemy):
		var arrow = arrow_scene.instantiate()
		add_child(arrow)
		arrows[enemy] = arrow
	return arrows[enemy]

func remove_arrow(enemy: Node2D) -> void:
	if arrows.has(enemy):
		arrows[enemy].queue_free()
		arrows.erase(enemy)

func get_clamped_to_screen_edge(pos: Vector2, screen_size: Vector2) -> Vector2:
	var margin: float = 32.0
	return pos.clamp(Vector2(margin, margin), screen_size - Vector2(margin, margin))
