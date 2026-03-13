extends Control
class_name ShopScreen



@export_category("References")
@export var background: TextureRect
@export var card_container: HBoxContainer
@export_category("Imports")
@export var card_commodity_scene: PackedScene = preload("res://scenes/ui/components/shop components/card_commodity.tscn")



func _ready():
	visible = false



func add_cards() -> void:
	for preset in Global.current_merchant.card_commodities:
		var card: CardCommodity = card_commodity_scene.instantiate()
		card.init(
			load(preset["sprite"]) as Texture2D,
			preset["price"]
		)
		
		card.pressed.connect(_on_card_pressed.bind(card, preset))
		
		card_container.add_child(card)

func clear_shop() -> void:
	for card in card_container.get_children():
		card.queue_free()



func _on_card_pressed(card: CardCommodity, preset: Dictionary) -> void:
	if Global.current_merchant.attempt_buy(preset):
		Global.UI.hud.hand_control.add_card(preset)
		card.sell()
