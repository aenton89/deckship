extends Node
class_name CardBonus



enum StatBoosts {CRIT_CHANCE, CRIT_AMOUNT, BOUNCE_AMOUNT, DMG, BULLET_SPEED, SHOOTING_ANGLE, ROTATE_SPEED}

var stat: StatBoosts
var value



func _init(bonus_stat: StatBoosts, bonus_value) -> void:
	stat = bonus_stat
	value = bonus_value
