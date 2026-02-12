extends Control
class_name ShopScreen



@export var background: TextureRect
@export var card_container: HBoxContainer



func _ready():
	visible = false


# on_stock_pressed() - do zakupu karty - sprawdza pieniądze, usuwa z card_display i listy u merchanta
# clear_shop() - czyści card_display, przed dodaniem nowych kart
# generate_shop_display(lista_kart) - instantiate na liście kart
