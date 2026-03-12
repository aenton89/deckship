extends StaticBody2D
class_name Merchant
## TODO:
# maszyna stanów - gracz mogłby być
# in_combat ALBO
# not_in_combat: roaming, in_shop_area, shopping -> potem można łatwo inne dodawać
#
# merchant działa tylko gdy gracz nie jest in_combat
# jak gracz jest w interaction_area, to LPM nie strzela
# tylko klikajać na merchant'a daje interakcje (otwiera sklep)
# PPM by wychodził ze sklepu
# 
# osobna scena na której jest cały sklep?



@export_category("References")
@export var interaction_area: Area2D
@export_category("Imports")
@export var card_scene: PackedScene = preload("res://scenes/items/card.tscn")
@export_category("Shop ware")
@export var card_stock_amount: int = 3
@export var multi_chance: float = 0.5

@onready var card_comodities: Array[Dictionary] = []



func _ready() -> void:
	Global.current_merchant = self
	
	randomize()
	# wylosować zestaw kart w obecnym sklepie
	generate_stock()



func pick_random_preset() -> Dictionary:
	# losowanie czy bierzemy single czy multi
	var use_multi: float = randf()
	
	if use_multi < multi_chance:
		return CardPresets.MULTI_BONUS_PRESETS[randi() % CardPresets.MULTI_BONUS_PRESETS.size()]
	else:
		return CardPresets.SINGLE_BONUS_PRESETS[randi() % CardPresets.SINGLE_BONUS_PRESETS.size()]
	return CardPresets.SINGLE_BONUS_PRESETS[randi() % CardPresets.SINGLE_BONUS_PRESETS.size()]

func generate_stock() -> void:
	for i in card_stock_amount:
		var preset: Dictionary = pick_random_preset()
		card_comodities.append(preset)

func enter_shop() -> void:
	Global.UI.hud.money_ui.show_money_ui()
	Global.UI.hud.money_ui.visible = true
	Global.UI.shop_ui.visible = true
	
	Global.UI.shop_ui.add_cards()

func exit_shop() -> void:
	Global.UI.hud.money_ui.hide_money_ui()
	Global.UI.shop_ui.visible = false
	
	Global.UI.shop_ui.clear_shop()

func stock_sold(preset: Dictionary) -> void:
	card_comodities.erase(preset)

func attempt_buy(preset: Dictionary) -> bool:
	if Global.player.money_component.pay(preset["price"]):
		card_comodities.erase(preset)
		return true
	
	return false



func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body is Player:
		# if !Global.player.in_combat:
			# Global.player.can_shop = true
		Global.player.can_shoot = false
		Global.player.can_move = false
		
		enter_shop()

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body is Player:
		# if !Global.player.in_combat:
			# Global.player.can_shop = false
		Global.player.can_shoot = true
		Global.player.can_move = true
		
		exit_shop()
