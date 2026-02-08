extends Control
class_name MoneyUI



@export_category("References")
@export var label: Label
@export var change_label: Label
@export_category("Settings")
@export var spacing: float = 40.0
@export var change_time: float = 0.5



func _ready() -> void:
	Global.player_ready.connect(_on_player_ready)
	change_label.visible = false
	label.visible = false
	change_label.text = ""
	label.text = "0"
	change_label.position.x = label.size.x + spacing



func _on_player_ready() -> void:
	label.text = str(Global.player.money_component.money)
	change_label.position.x = label.size.x + spacing
	
	Global.player.money_component.player_money_changed.connect(_on_money_changed)

func _on_money_changed(amount: int) -> void:
	label.visible = true
	
	var previous_amount: int = int(label.text)
	var operation_sign: String = "+"
	var await_time: float = change_time/amount
	
	if amount < 0:
		operation_sign = "-"
	
	change_label.visible = true
	change_label.text = operation_sign + str(amount)
	await get_tree().create_timer(0.2).timeout
	
	for i in range(amount, -1, -1):
		await get_tree().create_timer(await_time).timeout
		previous_amount += 1
		change_label.text = operation_sign + str(i)
		label.text = str(previous_amount)
	
	change_label.visible = false
	change_label.position.x = label.size.x + spacing
	
	label.text = str(Global.player.money_component.money)
	
	await get_tree().create_timer(1.5).timeout
	label.visible = false
