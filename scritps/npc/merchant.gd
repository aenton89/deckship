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

@onready var in_shop: bool = false



func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body is Player:
		# if !Global.player.in_combat:
			# Global.player.can_shop = true
		pass

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body is Player:
		# if !Global.player.in_combat:
			# Global.player.can_shop = false
		pass
