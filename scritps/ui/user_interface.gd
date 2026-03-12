extends CanvasLayer
class_name UserInterface



@export_category("References")
@export var hud: HUD
@export var shop_ui: ShopScreen
@export var death_screen: DeathScreen
@export var menu: Menu



func _ready() -> void:
	Global.UI = self
	visible = true
