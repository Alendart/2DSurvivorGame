extends Node

@export var axe_ability: PackedScene

@onready var timer:Timer = $Timer

var base_damage = 5
var actual_damage:int
var attacks_per_activation = 1
var default_wait_time

func _ready():
	default_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade)
	check_damage_upgrade()
	actual_damage = base_damage
	
	check_actual_player_upgrades()


func check_damage_upgrade():
	var current_modifier = MetaProgression.check_upgrade_lvl("damage")
	base_damage = base_damage + current_modifier



func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if player == null or foreground == null:
		return
	for i in attacks_per_activation:
		var axe_instance = axe_ability.instantiate() as Node2D
		foreground.add_child(axe_instance)
		axe_instance.global_position = player.global_position
		axe_instance.hitbox_component.damage = actual_damage
	
	
func check_actual_player_upgrades():
	var upgrade_manager = get_tree().get_first_node_in_group("Upgrade_manager")
	if upgrade_manager == null:
		return
	var current_upgrades = upgrade_manager.check_upgrades()
	if current_upgrades.has("player"):
		if current_upgrades["player"].has("damage"):
			actual_damage = base_damage + (5 * current_upgrades["player"]["damage"]["level"])
	return

func on_ability_upgrade(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.ability_type == "axe":
		if upgrade.id == "axe_rate":
			var reduction = current_upgrades["axe"]["axe_rate"]["level"] * 0.10
			timer.wait_time = default_wait_time * (1-reduction)
			timer.start()
		if upgrade.id == "axe_qty":
			attacks_per_activation = 1 + current_upgrades["axe"]["axe_qty"]["level"]
	elif upgrade.ability_type == "player":
		if upgrade.id == "damage":
			actual_damage = base_damage + (5 * current_upgrades["player"]["damage"]["level"])
