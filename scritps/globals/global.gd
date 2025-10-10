extends Node

### TODO:
# ui
# upgrades of the ship
# generating map for where the rocks spawn (or sth) - with cellular automata
# menu
# 



signal player_ready(player)

# test purposes
var game_paused: bool = false
var draw_debug: bool = false

var player: Player
var main: Node2D
var UI: UserInterface
var camera: Camera2D
