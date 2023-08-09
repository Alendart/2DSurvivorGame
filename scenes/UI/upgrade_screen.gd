extends CanvasLayer

signal upgrade_picked(upgrade:AbilityUpgrade)

@export var upgrade_card: PackedScene

@onready var card_container: HBoxContainer = %CardContainer

func _ready():
	get_tree().get_first_node_in_group("ArenaTimer").visible = false
	get_tree().paused = true
	

func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	var delay = 0
	for upgrade in upgrades:
		var card_instance = upgrade_card.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_in(delay)
		card_instance.clicked.connect(on_card_clicked.bind(upgrade))
		delay += 0.2
	

func on_card_clicked(upgrade:AbilityUpgrade):
	upgrade_picked.emit(upgrade)
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	get_tree().get_first_node_in_group("ArenaTimer").visible = true
	get_tree().paused = false
	queue_free()


