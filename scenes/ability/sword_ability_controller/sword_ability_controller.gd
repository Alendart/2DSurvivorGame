extends Node

@export var sword:PackedScene
@export var max_range = 150

@onready var timer:Timer = $Timer

var base_damage = 5
var actual_damage:int
var attacks_per_activation = 1
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
	if enemies_in_range.size() > 0:
		enemies_in_range.sort_custom(func(a:Node2D,b:Node2D):
			return a.global_position.distance_squared_to(player.global_position) < b.global_position.distance_squared_to(player.global_position)
		)
		
		for i in attacks_per_activation:
			if enemies_in_range.size() < (i+1):
				break
			var enemy_to_hit = enemies_in_range[i]
			var sword_scene = sword.instantiate() as SwordAbility
			var foregroud_layer = get_tree().get_first_node_in_group("foreground_layer")
			foregroud_layer.add_child(sword_scene)
			sword_scene.hitbox.damage = actual_damage
			
			sword_scene.global_position = enemy_to_hit.global_position
			sword_scene.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
			
			var enemy_direction = enemy_to_hit.global_position - sword_scene.global_position
			sword_scene.rotation = enemy_direction.angle()
	

func on_ability_upgrade(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.ability_type == "sword":
		if upgrade.id == "sword_rate":
			var reduction = current_upgrades["sword"]["sword_rate"]["level"] * 0.15
			timer.wait_time = default_wait_time * (1-reduction)
			timer.start()
		if upgrade.id == "sword_qty":
			attacks_per_activation = 1 + current_upgrades["sword"]["sword_qty"]["level"]
	elif upgrade.ability_type == "player":
		if upgrade.id == "damage":
			actual_damage = base_damage + (5 * current_upgrades["player"]["damage"]["level"])
	

