extends Node2D



@export_category("References")
@export var player: Player

var fps_label: Label



func _ready() -> void:
	Global.main = self
	
	randomize()
	player.hp_component.player_died.connect(_on_player_died)
	
	# licznik FPS
	if Global.draw_debug:
		fps_label = Label.new()
		fps_label.text = "FPS: 0"
		fps_label.add_theme_color_override("font_color", Color.WHITE)
		fps_label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
		add_child(fps_label)

func _process(_delta: float) -> void:
	if Global.draw_debug:
		fps_label.position = player.position
		fps_label.text = "FPS: %d" % Engine.get_frames_per_second()



func _on_player_died() -> void:
	await get_tree().create_timer(5).timeout
	get_tree().quit()
