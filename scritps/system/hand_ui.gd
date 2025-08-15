extends Control



var cards: Array[Node2D]= []
var radius = 200          # promień okręgu, po którym będą ustawione karty
var angle_spread = 40     # w stopniach – jak szeroki ma być wachlarz
var y_offset = 50



func _ready() -> void:
	for child in get_children():
		cards.append(child)
		update_card_positions()



func add_card(card_scene: PackedScene):
	var card = card_scene.instantiate()
	add_child(card)
	cards.append(card)
	update_card_positions()

func update_card_positions():
	if cards.size() == 0:
		return
	
	var center_x = size.x / 2
	var center_y = size.y
	
	var start_angle = -angle_spread / 2
	var step = angle_spread / max(cards.size() - 1, 1)
	
	for i in range(cards.size()):
		var angle_deg = start_angle + i * step
		var angle_rad = deg_to_rad(angle_deg)
		
		# pozycja w wachlarzu
		var x = center_x + radius * sin(angle_rad)
		var y = center_y - radius * (1 - cos(angle_rad)) - y_offset
		
		cards[i].position = Vector2(x, y)
		cards[i].rotation_degrees = angle_deg * 0.5 # delikatne obrócenie dla efektu
