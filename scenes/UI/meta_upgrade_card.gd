extends PanelContainer


@onready var name_label: Label = %NameLabel
@onready var desc_label: Label = %DescriptionLabel
@onready var ability_texture: TextureRect = %TextureRect
@onready var price_label : Label = %PriceLabel
@onready var purchase_button = %PurchaseButton
@onready var sold_label = %SoldLabel
@onready var lvl_label = %LvlLabel

var actual_upgrade:MetaUpgrade

func _ready():
	purchase_button.pressed.connect(on_purchase_button_pressed)

func check_price():
	var current_amount = MetaProgression.save_data["meta_upgrade_currency"]
	purchase_button.disabled = current_amount < actual_upgrade.money_cost

func check_upgrade_lvl():
	var actual_lvl = MetaProgression.check_upgrade_lvl(actual_upgrade.id)
	if actual_lvl < actual_upgrade.max_lvl:
		lvl_label.text = "%d" % actual_lvl +  " / %d" % actual_upgrade.max_lvl
	else:
		lvl_label.text = "%d" % actual_lvl +  " / %d" % actual_upgrade.max_lvl
		purchase_button.visible = false
		sold_label.visible = true
	

func set_meta_upgrade(upgrade: MetaUpgrade):
	if upgrade == null:
		return
	actual_upgrade = upgrade
	name_label.text = upgrade.title
	desc_label.text = upgrade.description
	ability_texture.texture = upgrade.texture
	price_label.text = "%2d" % upgrade.money_cost
	check_price()
	check_upgrade_lvl()


func select_card():
	$AnimationPlayer.play("selected")
	


func on_purchase_button_pressed():
	if actual_upgrade == null:
		return
	MetaProgression.save_data["meta_upgrade_currency"] -= actual_upgrade.money_cost
	GameEvents.emit_money_spend(MetaProgression.save_data["meta_upgrade_currency"])
	MetaProgression.add_meta_upgrade(actual_upgrade)
	get_tree().call_group("meta_upgrade_card", "check_price")
	get_tree().call_group("meta_upgrade_card", "check_upgrade_lvl")
	select_card()

