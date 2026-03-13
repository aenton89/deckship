extends Button
class_name CardCommodity



@export_category("References")
@export var card_texture: TextureRect
@export var price_label: Label
@export var coin_texture: TextureRect
@export_category("Imports")
@export var empty_card: CompressedTexture2D = preload("res://assets/cards/card_placeholder.png")



func _ready():
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL



func init(texture: Texture2D, price: int) -> void:
	price_label.text = str(price)
	card_texture.texture = texture

func sell() -> void:
	price_label.text = ""
	coin_texture.visible = false
	card_texture.texture = empty_card
