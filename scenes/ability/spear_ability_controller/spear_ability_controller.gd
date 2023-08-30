extends Node

@export var spear:PackedScene
@export var max_range = 100

@onready var timer:Timer = $Timer

var base_damage = 5
var actual_damage:int
var attacks_per_activation = 1
var size_modifier = 0
var lenght_modifier = 0
var default_wait_time


# Called when the node enters the scene tree for the first time.
func _ready():
	default_wait_time = timer.wait_time
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade)
	check_damage_upgrade()
	check_actual_player_upgrades()
	actual_damage = base_damage

func check_damage_upgrade():
	var current_modifier = MetaProgression.check_upgrade_lvl("damage")
	base_damage = base_damage + current_modifier

func check_actual_player_upgrades():
	var upgrade_manager = get_tree().get_first_node_in_group("Upgrade_manager")
	if upgrade_manager == null:
		return
	var current_upgrades = upgrade_manager.check_upgrades()
	if current_upgrades.has("player"):
		if current_upgrades["player"].has("damage"):
			actual_damage = base_damage + (5 * current_upgrades["player"]["damage"]["level"])
	return

func _on_timer_timeout():
	var enemies_list = get_tree().get_nodes_in_group("enemy")
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null or enemies_list.size() == 0:
		return
	var enemies_in_range = enemies_list.filter(func(enemy:Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range,2)
	)
	if enemies_in_range.size() == 0:
		return
		
	enemies_in_range.sort_custom(func(a:Node2D,b:Node2D):
		return a.global_position.distance_squared_to(player.global_position) < b.global_position.distance_squared_to(player.global_position)
	)
	
	for i in attacks_per_activation:
		var spear_instance = spear.instantiate()
		var forgroud_layer = get_tree().get_first_node_in_group("foreground_layer")
		forgroud_layer.add_child(spear_instance)
		spear_instance.hitbox.damage = actual_damage
		spear_instance.make_attack(enemies_in_range,i,size_modifier,lenght_modifier)
	


func on_ability_upgrade(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.ability_type == "spear":
		if upgrade.id == "spear_rate":
			var reduction = current_upgrades["spear"]["spear_rate"]["level"] * 0.15
			timer.wait_time = default_wait_time * (1-reduction)
			timer.start()
		if upgrade.id == "spear_qty":
			attacks_per_activation = 1 + current_upgrades["spear"]["spear_qty"]["level"]
		if upgrade.id == "spear_size":
			size_modifier = current_upgrades["spear"]["spear_size"]["level"]
		if upgrade.id == "spear_lenght":
			lenght_modifier = 0.15 * current_upgrades["spear"]["spear_lenght"]["level"]
	elif upgrade.ability_type == "player":
		if upgrade.id == "damage":
			actual_damage = base_damage + (5 * current_upgrades["player"]["damage"]["level"])
#


