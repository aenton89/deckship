extends RigidBody2D
class_name DamagableRB



@export_category("Components")
@export var hp_component: HPComponent
@export_category("References")
@export var sprite: Sprite2D
@export_category("Settings")
@export var flash_shader: Shader = preload("res://resources/effects/flash_material.gdshader")
@export var flash_on_hit: bool = true
@export var flash_time: float = 0.3



func _ready() -> void:
	if sprite:
		var fs_material: ShaderMaterial = ShaderMaterial.new()
		fs_material.shader = flash_shader
		sprite.material = fs_material

func flash() -> void:
	if flash_on_hit and sprite:
		sprite.material.set_shader_parameter("flash", true)
		
		var tween: Tween = create_tween()
		tween.tween_interval(flash_time)
		tween.tween_callback(func(): sprite.material.set_shader_parameter("flash", false))
