extends Node
class_name HPComponent

### TODO:
# analogicznie AttackComponent oraz HitboxComponent (czy na pewno potrzebne???)
# zamienić w damage amount: float na attack: AttackComponent
# youtube.com/watch?v=74y6zWZfQKk
#



signal player_died
signal player_took_dmg
signal player_healed

@export var max_health: float = 100.0

@onready var health: float = max_health



func init(amout: float) -> void:
	max_health = amout
	health = amout

func heal(amount: float) -> void:
	health += amount
	
	if get_parent().get_parent() == Global.player:
		emit_signal("player_healed")

func damage(amount: float) -> void:
	health -= amount
	
	if get_parent().get_parent() == Global.player:
		if health <= 0:
			emit_signal("player_died")
		else:
			emit_signal("player_took_dmg")
	else:
		if health <= 0:
			get_parent().get_parent().queue_free()
