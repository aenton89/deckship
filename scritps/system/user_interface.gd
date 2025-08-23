extends CanvasLayer
class_name UserInterface



@export_category("References")
@export var hp_label: Label
@export var hand_control: HandControl
@export var death_screen: Control
@export var animation_player: AnimationPlayer



func _ready() -> void:
	Global.UI = self
	death_screen.visible = false

func _process(delta: float) -> void:
	hp_label.text = "HP: " + str(Global.player.hp_component.health)
