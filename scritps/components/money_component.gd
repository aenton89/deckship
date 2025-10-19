extends Components
class_name MoneyComponent
# w HPComponent jest dodawania pieniążków dla gracza



signal player_money_changed(amount: int)

@export_category("Settings")
@export var money: int = 100



func add_money(amount: int) -> void:
	if parent is Player:
		emit_signal("player_money_changed", amount)
	money += amount

func remove_money(amount: int) -> void:
	if parent is Player:
		emit_signal("player_money_changed", -amount)
	money -= amount

func pay(amount: int) -> bool:
	if money >= amount:
		remove_money(amount)
		return true
	return false
