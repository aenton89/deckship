extends CanvasLayer
class_name UserInterface



@export_category("HUD")
@export var hp_label: Label
@export_category("Hand")
@export var hand_control: Control



func _process(delta: float) -> void:
	hp_label.text = "HP: " + str(Global.player.hp_component.health)
