extends Control
class_name Menu



func _ready() -> void:
	visible = false



func _on_start_button_pressed() -> void:
	print("GO TO NEW LVL, z fartem")

func _on_settings_button_pressed() -> void:
	pass

func _on_quit_button_pressed() -> void:
	get_tree().quit()
