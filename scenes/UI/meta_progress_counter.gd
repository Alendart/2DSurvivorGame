extends CanvasLayer

@onready var quantity_label = %QuantityLabel
var coins_qty = 0

func _ready():
	GameEvents.money_coin_collected.connect(on_money_coin_collect)
	update_coin_display()


func on_money_coin_collect(number: float):
	if number != null:
		coins_qty += number
		update_coin_display()

func update_coin_display():
	quantity_label.text = "%d" % coins_qty
