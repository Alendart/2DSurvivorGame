extends Node


@export var upgrade_pool: Array[AbilityUpgrade]
@export var upgrade_pool_weight: Array[int]
@export var ability_pool: Array[AbilityUpgrade]
@export var ability_pool_weight: Array[int]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_ability: Array[String]
var current_upgrade = {}
var current_lvl = 0

var upgrade_table = WeightedTable.new() as WeightedTable

func _ready():
	set_up_weighted_table()
	experience_manager.level_up.connect(on_level_up)
	

func set_up_weighted_table():
	var index = 0
	for upgrade in upgrade_pool:
		upgrade_table.add_item(upgrade,upgrade_pool_weight[index],upgrade.ability_type)
		index += 1
	
	var index2 = 0
	for ability in ability_pool:
		upgrade_table.add_item(ability,ability_pool_weight[index2],"ability")
		index2 += 1

func pick_upgrades():
	var choosen_upgrades: Array[AbilityUpgrade]
	
	if current_lvl == 1:
		var choosen_upgrades_array = upgrade_table.pick_item_from_categories(["ability"],3) as Array[AbilityUpgrade]
		for ability in choosen_upgrades_array:
				choosen_upgrades.append(ability)
	else:
		var filter_ability = current_ability.duplicate(true)
		filter_ability.append("ability")
		var choosen_upgrades_array = upgrade_table.pick_item_from_categories(filter_ability as Array[String],3) as Array[AbilityUpgrade]
		for ability in choosen_upgrades_array:
				choosen_upgrades.append(ability)
	
	return choosen_upgrades

func check_upgrades():
	return current_upgrade

func on_level_up(lvl:int):
	current_lvl = lvl
	var choosen_upgrades = pick_upgrades()
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades(choosen_upgrades)
	upgrade_screen_instance.upgrade_picked.connect(on_upgrade_picked)

func apply_upgrades(upgrade: AbilityUpgrade):
	if upgrade.id == upgrade.ability_type:
		current_ability.append(upgrade.id)
		current_upgrade[upgrade.id] = {}
		upgrade_table.delete_item(upgrade)
		GameEvents.emit_new_ability_added(upgrade as Ability, current_ability)
		if !current_ability.has("player"):
				current_upgrade["player"]={}
				current_ability.append("player")
		return
	
	var has_upgrade = current_upgrade[upgrade.ability_type].has(upgrade.id)
	if !has_upgrade:
		current_upgrade[upgrade.ability_type][upgrade.id] = {
			"resource": upgrade,
			"level": 1
		}
	else:
		current_upgrade[upgrade.ability_type][upgrade.id]["level"] += 1
	
	if current_upgrade[upgrade.ability_type][upgrade.id]["level"] == upgrade.max_lvl:
		upgrade_table.delete_item(upgrade)
		
	
	GameEvents.emit_ability_upgrade_added(upgrade,current_upgrade)
	

func on_upgrade_picked(upgrade: AbilityUpgrade):
	apply_upgrades(upgrade)

