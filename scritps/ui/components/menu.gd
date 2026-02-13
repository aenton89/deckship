extends Control
class_name Menu



@export var main_menu: VBoxContainer
@export var settings_menu: VBoxContainer



func _ready() -> void:
	visible = false



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
