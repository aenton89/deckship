extends Node2D



@export_category("Imports")
@export var player_scene: PackedScene = preload("res://scenes/player/player.tscn")
@export_category("References")
@export var multiplayer_ui: CanvasLayer
@export var death_screen: CanvasLayer
@export var player: Player
@export var animations: AnimationPlayer

#var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()



func _ready() -> void:
	Global.main = self
	randomize()
	player.hp_component.connect("player_died", Callable(self, "on_player_died"))



func on_player_died() -> void:
	Global.UI.animation_player.play("death_screen_fade")
	
	await get_tree().create_timer(3).timeout
	get_tree().quit()
