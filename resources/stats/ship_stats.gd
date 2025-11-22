extends Resource
class_name ShipStats



@export_category("Attack")
@export_subgroup("Crits")
@export var crit_chance: float = 0.1
@export var crit_amount: float = 1.2
@export_subgroup("Bullet")
@export var bullet_speed: float = 1000.0
@export var bullet_explosion_force: float = 400.0
@export_subgroup("Shooting")
@export var bounce_amount: int = 1
@export var dmg: float = 10.0
@export var shooting_angle: float = PI/4

@export_category("Movement")
@export_subgroup("Dodge")
@export var dodge_strength: float = 400.0
@export var dodge_cooldown: float = 2.0
@export var dodge_amount: int = 0
@export_subgroup("Rotation")
@export var rotate_speed: float = 5.0

@export_category("Ship Details")
@export var max_hp: float = 100.0
