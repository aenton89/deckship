extends Components
class_name MoneyComponent



@onready var money: int = 0



func add_money(amount: int) -> void:
	money += amount

func remove_money(amount: int) -> void:
	money -= amount

func pay(amount: int) -> bool:
	if money >= amount:
		remove_money(amount)
		return true
	return false
