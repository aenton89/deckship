extends Node2D



@export_category("References")
@export var player: Player



func _ready() -> void:
	Global.main = self
	
	randomize()
	player.hp_component.player_died.connect(_on_player_died)



func _on_player_died() -> void:
	await get_tree().create_timer(5).timeout
	get_tree().quit()
