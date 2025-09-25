extends Resource
class_name PlayerStats



@export_category("Crits")
@export var crit_chance: float = 0.1
@export var crit_amount: float = 1.2
@export_category("Shooting")
@export var bounce_amount: int = 1
@export var dmg: float = 10.0
@export var bullet_speed: float = 1000.0
@export_category("Ship Details")
@export var shooting_angle: float = PI/4
@export var rotate_speed: float = 5.0
