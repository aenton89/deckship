extends Node2D



@export_category("Imports")
@export var player_scene: PackedScene = preload("res://scenes/player/player.tscn")
@export_category("References")
@export var multiplayer_ui: CanvasLayer

#var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()



func _ready() -> void:
	randomize()
	Global.main = self



#func _on_host_pressed() -> void:
	#print("hosting...")
	#
	#peer.create_server(25565)
	#multiplayer.multiplayer_peer = peer
	#
	#multiplayer_ui.visible = false
	#
	#multiplayer.peer_connected.connect(
		#func(pid):
			#print("peer: " + str(pid) + " joined")
			#add_player(pid)
	#)
	#
	#add_player(multiplayer.get_unique_id())

#func _on_join_pressed() -> void:
	#print("joined")
	#
	#peer.create_client("localhost", 25565)
	#multiplayer.multiplayer_peer = peer
	#
	#multiplayer_ui.visible = false



#func add_player(pid: int) -> void:
	#var player = player_scene.instantiate()
	#player.name = str(pid)
	#
	#add_child(player)
