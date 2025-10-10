extends Control
class_name HUD



@export_category("References")
@export var hp_bar: TextureProgressBar



func _ready() -> void:
	Global.player_ready.connect(_on_player_ready)



func _on_player_ready() -> void:
	hp_bar.min_value = 0
	hp_bar.max_value = Global.player.hp_component.max_health
	hp_bar.value = Global.player.hp_component.health
	
	Global.player.hp_component.player_healed.connect(_on_hp_changed)
	Global.player.hp_component.player_took_dmg.connect(_on_hp_changed)

func _on_hp_changed() -> void:
	hp_bar.value = Global.player.hp_component.health
