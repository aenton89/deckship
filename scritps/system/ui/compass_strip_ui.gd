extends TextureRect
class_name CompassStrip



@onready var mat: ShaderMaterial = material as ShaderMaterial



func _process(_delta: float) -> void:
	if Global.player == null:
		return
	
	# oblicz przesunięcie względem rotacji gracza
	var angle_deg = rad_to_deg(Global.player.global_rotation)
	
	# przeliczamy kąt na offset (pełny obrót = 1.0 UV)
	var offset_x = fmod(angle_deg / 360.0, 1.0)
	
	# ustaw offset w shaderze
	mat.set_shader_parameter("offset_x", offset_x)
