extends Control
class_name DeathScreen



var death_animation_played: bool = false



func _ready() -> void:
	visible = false
	
	Global.player_ready.connect(_on_player_ready)



func _on_player_ready() -> void:
	Global.player.hp_component.player_died.connect(_on_player_died)

func _on_player_died() -> void:
	if !death_animation_played:
		death_animation_played = true
		
		Global.UI.animation_player.play("death_screen_fade")
		
		# pousuwaj pozostały HUD
		Global.UI.arrow_container.visible = false
		Global.UI.hud.visible = false
		Global.UI.hand_control.visible = false
