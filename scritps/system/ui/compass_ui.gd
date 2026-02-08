extends Control
class_name CompassUI



@export_category("References")
@export var compass: TextureRect
@export var needle: TextureRect

@onready var mat: ShaderMaterial = compass.material as ShaderMaterial



func _process(_delta: float) -> void:
	if Global.player == null:
		return
	
	# przesunięcie względem rotacji gracza (+ jakis błąd kąta co mi wyszedł idk)
	var angle_deg: float = rad_to_deg(Global.player.global_rotation) + (180 + 45)
	
	# przeliczamy kąt na offset (pełny obrót = 1.0 UV)
	var offset_x: float = fmod(angle_deg / 360.0, 1.0)
	
	# ustaw offset w shaderze
	mat.set_shader_parameter("offset_x", offset_x)
