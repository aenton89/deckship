extends CanvasLayer
class_name UserInterface



@export_category("References")
@export var hp_bar: TextureProgressBar
@export var hand_control: HandControl
@export var death_screen: Control
@export var animation_player: AnimationPlayer

var death_animation_played: bool = false



func _ready() -> void:
	Global.UI = self
	death_screen.visible = false
	
	Global.player_ready.connect(_on_player_ready)



func _on_player_ready() -> void:
	hp_bar.min_value = 0
	hp_bar.max_value = Global.player.hp_component.max_health
	hp_bar.value = Global.player.hp_component.health
	
	Global.player.hp_component.player_died.connect(_on_player_died)
	Global.player.hp_component.player_healed.connect(_on_hp_changed)
	Global.player.hp_component.player_took_dmg.connect(_on_hp_changed)

func _on_player_died() -> void:
	if !death_animation_played:
		death_animation_played = true
		animation_player.play("death_screen_fade")

func _on_hp_changed() -> void:
	hp_bar.value = Global.player.hp_component.health
