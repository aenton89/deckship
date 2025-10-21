extends StaticBody2D
class_name Merchant



signal merchant_area_entered

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
