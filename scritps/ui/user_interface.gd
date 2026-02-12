extends CanvasLayer
class_name UserInterface



@export_category("References")
@export var hud: HUD
@export var shop_ui: ShopScreen
@export var death_screen: DeathScreen



func _ready() -> void:
	Global.UI = self
	visible = true
	
	# test purposes
	var enemies_in_world: Array[Node] = get_tree().get_nodes_in_group("enemies")
	hud.arrow_container.enemies = enemies_in_world
