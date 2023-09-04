extends Node

@export var arena_time_manager: Node
@export var basic_rat: PackedScene
@export var tough_rat: PackedScene
@export var wizard_enemy: PackedScene
@export var dark_rat: PackedScene
@export var ghost_enemy: PackedScene
@export var boss_enemy: PackedScene

@onready var timer: Timer = $Timer
@onready var hyper_wave_timer: Timer = $HyperWaveTimer

var difficulty_timer_decrease = 0.05
var spawn_area = 375
var base_wait_time = 0
var hyper_wave_base_wait_time = 0
var enemy_table = WeightedTable.new()

func _ready():
	enemy_table.add_item(basic_rat,10)
	
	base_wait_time = timer.wait_time
	hyper_wave_base_wait_time = hyper_wave_timer.wait_time
	arena_time_manager.rise_difficulty.connect(on_rise_difficulty)
	hyper_wave_timer.timeout.connect(on_hyper_wave_timer_timeout)



func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	var spawn_position = Vector2.ZERO
	
	for i in 4:
		
		spawn_position = player.global_position + (random_direction * spawn_area)
		
		var ray_parameters = PhysicsRayQueryParameters2D.create(player.global_position,spawn_position,1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(ray_parameters)	
	
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position

func _on_timer_timeout():
	timer.start()
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemy = enemy_table.pick_item()[0] as PackedScene
	var enemy_instance = enemy.instantiate()
	var entites_layer = get_tree().get_first_node_in_group("entities_layer")
	entites_layer.add_child(enemy_instance)
	enemy_instance.global_position = get_spawn_position()
	

func start_boss_fight():
	var boss_enemy_instance = boss_enemy.instantiate()
	var entites_layer = get_tree().get_first_node_in_group("entities_layer")
	entites_layer.add_child(boss_enemy_instance)
	boss_enemy_instance.global_position = get_spawn_position()

func on_rise_difficulty(lvl:int):
	var new_wait_time = base_wait_time - (lvl * difficulty_timer_decrease)
	if new_wait_time <= 0.05:
		timer.wait_time = 0.01
		hyper_wave_timer.start()
		print("Its begin...")
	else:
		timer.wait_time = new_wait_time
	
	
	if lvl == 10:
		enemy_table.add_item(tough_rat,10)
		start_boss_fight()
	if lvl == 20:
		enemy_table.add_item(wizard_enemy,15)
	if lvl == 30:
		enemy_table.delete_item(basic_rat)
	if lvl == 40:
		enemy_table.add_item(dark_rat,10)
	if lvl == 50:
		enemy_table.delete_item(tough_rat)
		enemy_table.add_item(ghost_enemy, 30)
	if lvl == 80:
		enemy_table.delete_item(ghost_enemy)

func on_hyper_wave_timer_timeout():
	print("Time to rest...")
	base_wait_time = base_wait_time + 0.5
	timer.wait_time = base_wait_time
	hyper_wave_base_wait_time = hyper_wave_base_wait_time + 0.25
	hyper_wave_timer.wait_time = hyper_wave_base_wait_time

