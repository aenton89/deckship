extends Node
class_name CardPresets



# karty z JEDNYM bonusem
static var SINGLE_BONUS_PRESETS: Array = [
	{
		"name": "DMG_DEFAULT",
		"bonuses": [
			{"type": Bonus.StatBoosts.DMG, "value": 10}
		],
		"sprite": "res://assets/cards/card_02.png"
	},
	{
		"name": "CRIT_CHANCE_DEFAULT",
		"bonuses": [
			{"type": Bonus.StatBoosts.CRIT_CHANCE, "value": 0.1}
		],
		"sprite": "res://assets/cards/card_01.png"
	}
]

# karty z DWOMA bonusami
static var MULTI_BONUS_PRESETS: Array = [
	{
		"name": "CRIT_CHANCE_N_DMG_DEFAULT",
		"bonuses": [
			{"type": Bonus.StatBoosts.CRIT_CHANCE, "value": 0.05},
			{"type": Bonus.StatBoosts.DMG, "value": 5}
		],
		"sprite": "res://assets/cards/card_03.png"
	}
]
