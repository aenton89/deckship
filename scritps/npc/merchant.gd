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
@export var card_stock: int = 5
@export var single_bonus_chance: float = 0.6

@onready var card_comodities: Array[Card] = []
@onready var player_in_shop: bool = false



# generate_stock() - losuje jakieś karty
# pass_to_display() - przekazuje do ui, co ma być instantiate'ed
# delete_stock() - usuwa kartę, wywoływane przez shop_screen_ui



func _ready() -> void:
	# wylosować zestaw kart w obecnym sklepie
	pass



func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body is Player:
		# if !Global.player.in_combat:
			# Global.player.can_shop = true
		Global.player.can_shoot = false
		Global.UI.shop_ui.visible = true
		player_in_shop = true

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body is Player:
		# if !Global.player.in_combat:
			# Global.player.can_shop = false
		Global.player.can_shoot = true
		Global.UI.shop_ui.visible = false
		player_in_shop = false
