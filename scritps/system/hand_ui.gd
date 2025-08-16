extends Control



@export_category("Offsets")
@export var angle_offset: float = PI/16
@export var x_offset_diff: float = 100.0
@export var y_offset_diff: float = 10.0

@onready var cards: Array[Card]= []
@onready var even: bool = false
var angle: float = PI/64
var x_offset: float = 100.0
var y_offset: float = 5.0
var y_default: float = 50
var i: int = 0



func _ready() -> void:
	for child in get_children():
		if child is Card:
			cards.append(child)
		
	
	i = -cards.size()/2
	
	### TODO: pomyśleć
	if cards.size()%2 == 0:
		even = true
	
	update_card_positions()



#func add_card(card_scene: PackedScene):
	#var card = card_scene.instantiate()
	#add_child(card)
	#cards.append(card)
	#update_card_positions()
	#
	#i = -cards.size()/2

func update_card_positions():
	for card in cards:
		angle = angle_offset * i
		x_offset = x_offset_diff * i
		y_offset = y_offset_diff * i * i
		
		print("angle: ", angle, " x_offset: ", x_offset, " y_offset: ", y_offset)
		
		card.base_y = size.y - y_default + y_offset
		
		card.position = Vector2(size.x/2 + x_offset, size.y - y_default + y_offset)
		card.rotate(angle)
		
		print("pos: ", card.position, " rot: ", card.rotation_degrees)
		
		i += 1
