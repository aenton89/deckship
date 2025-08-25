extends Node2D
class_name Card



@export_category("References")
@export var area: Area2D
@export var sprite: Sprite2D
@export_category("Hoover Actions")
@export var y_change: float = 80.0
@export_category("Tween")
@export var up_duration: float = 0.2
@export var down_duration: float = 0.4
@export var trans: Tween.TransitionType = Tween.TRANS_SINE
@export var ease: Tween.EaseType = Tween.EASE_IN_OUT

var bonuses: Array[Bonus] = []
var current_tween: Tween = null
var base_y: float
var hovered: bool = false



func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot_and_move") and Input.is_action_pressed("cards_interactions") and hovered:
		print("card pressed")
		Global.UI.hand_control.apply_card(self)



func _on_area_2d_mouse_entered() -> void:
	hovered = true
	if Input.is_action_pressed("cards_interactions"):
		animate_to(base_y - y_change, up_duration)

func _on_area_2d_mouse_exited() -> void:
	hovered = false
	animate_to(base_y, down_duration)



func setup(preset: Dictionary) -> void:
	# ustaw bonusy
	bonuses = []
	for bonus_data in preset["bonuses"]:
		var b = Bonus.new(bonus_data["type"], bonus_data["value"])
		bonuses.append(b)
	
	# ustaw grafikę
	if preset.has("sprite") and sprite:
		sprite.texture = load(preset["sprite"])

func animate_to(target_y: float, duration: float) -> void:
	# jeśli istnieje stary tween → poczekaj
	if current_tween and current_tween.is_running():
		await current_tween.finished
	
	current_tween = create_tween()
	current_tween.tween_property(self, "position:y", target_y, duration).set_trans(trans).set_ease(ease)
