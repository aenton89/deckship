extends Control
class_name ShopScreen



@export var background: TextureRect
@export var card_container: HBoxContainer



func _ready():
	visible = false



func add_cards() -> void:
	for preset in Global.current_merchant.card_comodities:
		var card: TextureRect = TextureRect.new()
		card.texture = load(preset["sprite"]) as Texture2D
		card.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		
		card.mouse_filter = Control.MOUSE_FILTER_STOP
		card.gui_input.connect(_on_card_clicked.bind(card, preset))
		
		card_container.add_child(card)

func clear_shop() -> void:
	for card in card_container.get_children():
		card.queue_free()



func _on_card_clicked(event: InputEvent, card: TextureRect, preset: Dictionary) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if Global.current_merchant.attempt_buy(preset):
			Global.UI.hud.hand_control.add_card(preset)
			card.queue_free()
