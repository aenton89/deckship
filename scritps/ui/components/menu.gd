extends Control
class_name Menu



@export_category("References")
@export var main_menu: VBoxContainer
@export var settings_menu: VBoxContainer
@export var animation_player: AnimationPlayer

@onready var is_pause_menu: bool = false



func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if is_pause_menu:
			if get_tree().paused:
				resume()
			else:
				pause()



func resume() -> void:
	get_tree().paused = false
	visible = false
	animation_player.play_backwards("blur")

func pause() -> void:
	get_tree().paused = true
	visible = true
	animation_player.play("blur")



func _on_start_button_pressed() -> void:
	Global.lvl_manager.curr_level.exit_level()

func _on_settings_button_pressed() -> void:
	main_menu.visible = false
	settings_menu.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_back_button_pressed() -> void:
	main_menu.visible = true
	settings_menu.visible = false

func _on_crt_effect_check_button_toggled(toggled_on: bool) -> void:
	Global.main.shader.visible = !Global.main.shader.visible
