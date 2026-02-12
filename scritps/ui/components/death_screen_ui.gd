extends Control
class_name DeathScreen



@export_category("References")
@export var animation_player: AnimationPlayer

var death_animation_played: bool = false



func _ready() -> void:
	visible = false
	
	Global.player_ready.connect(_on_player_ready)



func _on_player_ready() -> void:
	Global.player.hp_component.player_died.connect(_on_player_died)

func _on_player_died() -> void:
	if !death_animation_played:
		death_animation_played = true
		
		animation_player.play("death_screen_fade")
		
		# pousuwaj pozostały HUD
		Global.UI.hud.arrow_container.visible = false
		Global.UI.hud.hp_bar.visible = false
		Global.UI.hud.hand_control.visible = false
		Global.UI.hud.compass_ui.visible = false
		Global.UI.hud.money_ui.visible = false
		Global.UI.hud.dodge_ui.visible = false
