extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] 
@onready var back_button = %BackButton
@onready var grid_container = %GridContainer


var meta_upgrade_scene = preload("res://scenes/UI/meta_upgrade_card.tscn")

func _ready():
	for child in grid_container.get_children():
		child.queue_free()
	
	back_button.pressed.connect(on_back_pressed)
	GameEvents.emit_money_coin_collected(MetaProgression.save_data["meta_upgrade_currency"])
	
	for upgrade in upgrades:
		var meta_upgrade_car_instance = meta_upgrade_scene.instantiate()
		grid_container.add_child(meta_upgrade_car_instance)
		meta_upgrade_car_instance.set_meta_upgrade(upgrade)

func on_back_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transition_halfway
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
