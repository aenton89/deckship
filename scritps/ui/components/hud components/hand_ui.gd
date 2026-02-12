extends Control
class_name HandControl


@export_category("Offsets")
@export var angle_offset: float = PI/16
@export var x_offset_diff: float = 100.0
@export var y_offset_diff: float = 10.0
@export_category("Imports")
@export var card_scene: PackedScene = preload("res://scenes/items/card.tscn")

@onready var even: bool = false
var y_default: float = 50
var i: float = 0.0
var cards: Array[Card] = []



func add_card(preset: Dictionary) -> void:
	var card: Card = card_scene.instantiate() as Card
	card.setup(preset)
	add_child(card)
	cards.append(card)
	update_card_positions()

func remove_card(card_to_remove: Card) -> void:
	if card_to_remove in cards:
		cards.erase(card_to_remove)
		card_to_remove.queue_free()
		update_card_positions()

func apply_card(card: Card) -> void:
	for bonus in card.bonuses:
		match bonus.stat:
			CardBonus.StatBoosts.DMG:
				Global.player.stats.dmg += bonus.value
			CardBonus.StatBoosts.CRIT_CHANCE:
				Global.player.stats.crit_chance += bonus.value
	
	remove_card(card)

func update_card_positions():
	var n: int = cards.size()
	var start: float
	
	# np. dla 4 kart: start = -1.5
	if n % 2 == 0:
		start = -(n / 2.0 - 0.5)
	 # np. dla 5 kart: start = -2
	else:
		start = -floor(n / 2)
	
	i = start
	for card in cards:
		var angle: float = angle_offset * i
		var x_offset: float = x_offset_diff * i
		var y_offset: float = y_offset_diff * i * i
		
		card.base_y = size.y - y_default + y_offset
		card.position = Vector2(size.x/2 + x_offset, card.base_y)
		card.rotation = angle
		
		i += 1
