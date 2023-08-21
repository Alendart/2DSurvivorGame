extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] 
@onready var grid_container = $MarginContainer/GridContainer

var meta_upgrade_scene = preload("res://scenes/UI/meta_upgrade_card.tscn")

func _ready():
	for upgrade in upgrades:
		var meta_upgrade_car_instance = meta_upgrade_scene.instantiate()
		grid_container.add_child(meta_upgrade_car_instance)
		meta_upgrade_car_instance.set_meta_upgrade(upgrade)

