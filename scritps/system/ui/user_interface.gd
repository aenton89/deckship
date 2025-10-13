extends CanvasLayer
class_name UserInterface



@export_category("References")
@export var hud: HUD
@export var hand_control: HandControl
@export var death_screen: DeathScreen
@export var arrow_container: ArrowContainer
@export var compass_strip: CompassStrip
@export var animation_player: AnimationPlayer



func _ready() -> void:
	Global.UI = self
	visible = true
	
	# test purposes
	var enemies_in_world = get_tree().get_nodes_in_group("enemies")
	arrow_container.enemies = enemies_in_world
