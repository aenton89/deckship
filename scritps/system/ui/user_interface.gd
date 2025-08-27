extends CanvasLayer
class_name UserInterface



@export_category("References")
@export var hp_bar: TextureProgressBar
@export var hand_control: HandControl
@export var death_screen: Control
@export var animation_player: AnimationPlayer



func _ready() -> void:
	Global.UI = self
	death_screen.visible = false
	
	Global.player_ready.connect(_on_player_ready)

func _process(delta: float) -> void:
	hp_bar.value = Global.player.hp_component.health



func _on_player_ready() -> void:
	hp_bar.min_value = 0
	hp_bar.max_value = Global.player.hp_component.max_health
	hp_bar.value = Global.player.hp_component.health
