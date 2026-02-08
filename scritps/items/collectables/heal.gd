extends Node2D
class_name Heal



@export_category("References")
@export var sprite: Sprite2D
@export_category("Heal Amount")
@export var heal_amount: float = 20.0

@onready var used: bool = false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if !used:
		if body is Player:
			used = true
			Global.player.hp_component.heal(heal_amount)
			
			# animacja (tween w górę i powrót)
			var original_y: float = position.y
			var tween: Tween = create_tween()
			tween.tween_property(self, "position:y", position.y - 50, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(self, "position:y", original_y, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			
			# po skończeniu tween'a usuń się
			tween.finished.connect(func(): queue_free())
