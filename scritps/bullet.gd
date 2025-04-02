extends Area2D
class_name bullet

@export var speed: float = 500
var direction: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	position += speed * direction * delta

# funkcja on_bullet_target_entered() czy cos takiego napisac
func _on_body_entered(body: Node2D) -> void:
	if body.get_parent().is_in_group("player") or body.is_in_group("player"):
		pass
	else:
		body.queue_free()
		queue_free()
