extends Node

@export var spear:PackedScene
@export var max_range = 100

@onready var timer:Timer = $Timer

var base_damage = 5
var actual_damage:int
var attacks_per_activation = 1
var default_wait_time


# Called when the node enters the scene tree for the first time.
func _ready():
	default_wait_time = timer.wait_time
#	GameEvents.ability_upgrade_added.connect(on_ability_upgrade)
	actual_damage = base_damage


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
	
	var spear_instance = spear.instantiate()
	var forgroud_layer = get_tree().get_first_node_in_group("foreground_layer")
	forgroud_layer.add_child(spear_instance)
	spear_instance.make_attack()
	

#func on_ability_upgrade(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
#	if upgrade.ability_type == "sword":
#		if upgrade.id == "sword_rate":
#			var reduction = current_upgrades["sword"]["sword_rate"]["level"] * 0.15
#			timer.wait_time = default_wait_time * (1-reduction)
#			timer.start()
#		if upgrade.id == "sword_qty":
#			attacks_per_activation = 1 + current_upgrades["sword"]["sword_qty"]["level"]
#	elif upgrade.ability_type == "player":
#		if upgrade.id == "damage":
#			actual_damage = base_damage + (1 * current_upgrades["player"]["damage"]["level"])
#


