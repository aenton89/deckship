extends Control
class_name DodgeUI



# tekstura pasków
@export var example_bar: TextureProgressBar

# ile pasków
@onready var amount: int = 0
var bars: Array[TextureProgressBar] = []



func _ready() -> void:
	Global.player_ready.connect(_on_player_ready)



func _on_player_ready() -> void:
	add_bars()



func add_bars() -> void:
	if Global.player.stats.dodge_amount > amount:
		for i in range(Global.player.stats.dodge_amount - amount):
			var bar: TextureProgressBar = example_bar.duplicate()
			bar.value = 100
			bar.min_value = 0
			bar.max_value = 100
			bar.position = Vector2(example_bar.position.x + (amount + i) * (example_bar.size.x + 30), example_bar.position.y)
			bar.size = example_bar.size
			
			add_child(bar)
			bars.append(bar)
		amount = Global.player.stats.dodge_amount

func remove_bars() -> void:
	if Global.player.stats.dodge_amount < amount:
		for i in range(amount - Global.player.stats.dodge_amount):
			bars.back().queue_free()
		amount = Global.player.stats.dodge_amount

func start_cooldown(index: int) -> void:
	if index < 0 or index >= bars.size():
		return
	
	bars[index].value = 0
	
	var tween: Tween = create_tween()
	tween.tween_property(bars[index], "value", 100.0, Global.player.stats.dodge_cooldown)
