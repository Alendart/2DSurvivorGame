extends Node


@export var upgrade_pool: Array[AbilityUpgrade]
@export var upgrade_pool_weight: Array[int]
@export var ability_pool: Array[AbilityUpgrade]
@export var ability_pool_weight: Array[int]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_ability= {}
# Tutaj można przerobić ability na tablicę stringów zamiast na obiekt
var current_upgrade = {}

var upgrade_table = WeightedTable.new() as WeightedTable

func _ready():
	experience_manager.level_up.connect(on_level_up)
	set_up_weighted_table()


func set_up_weighted_table():
	var index = 0
	for upgrade in upgrade_pool:
		upgrade_table.add_item(upgrade,upgrade_pool_weight[index],"upgrade")
		index += 1
	
	var index2 = 0
	for ability in ability_pool:
		upgrade_table.add_item(ability,ability_pool_weight[index],"ability")
		index += 1

func pick_upgrades():
	var choosen_upgrades: Array[AbilityUpgrade]
	
	var filtered_upgrade_pool:Array[AbilityUpgrade] = upgrade_pool.filter(func(i:AbilityUpgrade):
		if current_ability.has(i.ability_type):
			if current_upgrade[i.ability_type].has(i.id):
				if current_upgrade[i.ability_type][i.id]["level"] >= i.max_lvl:
					return false
			return true
		else:
			return false
		)
	var filtered_ability_pool:Array[AbilityUpgrade] = ability_pool.filter(func(i:AbilityUpgrade):return !current_ability.has(i.id))
	var total_skills_pool = filtered_ability_pool+filtered_upgrade_pool
	
	for i in 3:
		if total_skills_pool.size() <= 0:
			break
		var choosen = total_skills_pool.pick_random() as AbilityUpgrade
		choosen_upgrades.append(choosen)
		total_skills_pool = total_skills_pool.filter(func(i:AbilityUpgrade):
			return choosen != i
			)
	
	return choosen_upgrades





func on_level_up(lvl:int):
	
	var choosen_upgrades = pick_upgrades()
	
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades(choosen_upgrades)
	upgrade_screen_instance.upgrade_picked.connect(on_upgrade_picked)



func apply_upgrades(upgrade: AbilityUpgrade):
	if upgrade.id == upgrade.ability_type:
		current_ability[upgrade.id] = upgrade
		current_upgrade[upgrade.id] = {}
		GameEvents.emit_new_ability_added(upgrade as Ability, current_ability)
		if !current_ability.has("player"):
				current_upgrade["player"]={}
				current_ability["player"]={}
		return
	
	var has_upgrade = current_upgrade[upgrade.ability_type].has(upgrade.id)
	if !has_upgrade:
		current_upgrade[upgrade.ability_type][upgrade.id] = {
			"resource": upgrade,
			"level": 1
		}
	else:
		current_upgrade[upgrade.ability_type][upgrade.id]["level"] += 1
		
	
	GameEvents.emit_ability_upgrade_added(upgrade,current_upgrade)
	

func on_upgrade_picked(upgrade: AbilityUpgrade):
	apply_upgrades(upgrade)

