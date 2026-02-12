extends TextureProgressBar
class_name HPBar



func _ready() -> void:
	Global.player_ready.connect(_on_player_ready)



func _on_player_ready() -> void:
	min_value = 0
	max_value = Global.player.hp_component.max_health
	value = Global.player.hp_component.health
	
	Global.player.hp_component.player_healed.connect(_on_hp_changed)
	Global.player.hp_component.player_took_dmg.connect(_on_hp_changed)

func _on_hp_changed() -> void:
	value = Global.player.hp_component.health
