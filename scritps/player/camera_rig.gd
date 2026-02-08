extends Node2D
class_name CameraRig



@export_category("References")
@export var camera: Camera2D
@export_category("Screen Shake Settings")
@export var shake_duration: float = 0.8
@export var shake_magnitude: float = 20.0



func _ready() -> void:
	Global.camera = camera



func shake_camera() -> void:
	var tween: Tween = create_tween()
	
	for i in range(10):
		var offset: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_magnitude
		tween.tween_property(self, "position", offset, shake_duration / 10)
	tween.tween_property(self, "position", Vector2.ZERO, shake_duration / 10)
