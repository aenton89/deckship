extends Control
class_name DodgeUI



# tekstura pasków
@export var cooldown_bar: TextureProgressBar

# ile pasków
@onready var amount: int = 0
var bars: Array[TextureProgressBar] = []



func _ready() -> void:
	Global.player_ready.connect(_on_player_ready)



func _on_player_ready() -> void:
	add_bars(Global.player.stats.dodge_amount)



func add_bars(how_many: int) -> void:
	if amount + how_many <= Global.player.stats.dodge_amount and how_many > 0:
		for i in range(how_many):
			var bar: TextureProgressBar = cooldown_bar.duplicate()
			bar.value = 100
			bar.scale = Vector2(1, 1)
			bar.position = Vector2(2*cooldown_bar.position.x + 20 + (amount + i) * (bar.size.x + 5), cooldown_bar.position.y)
			bar.size = cooldown_bar.size
			
			add_child(bar)
			bars.append(bar)
		amount += how_many

func remove_bars(how_many: int) -> void:
	if how_many >= 0 and how_many <= amount:
		for i in range(how_many):
			var last = bars.pop_back()
			last.queue_free() 
		amount -= how_many

func start_cooldown() -> void:
	cooldown_bar.value = 0
	
	var tween: Tween = create_tween()
	tween.tween_property(cooldown_bar, "value", 100.0, Global.player.stats.dodge_cooldown)
