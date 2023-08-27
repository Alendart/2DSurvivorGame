extends Node
class_name MoneyDropComponent

@export_range(0,1) var drop_percent: float = 0.5 
@export var health_component: Node
@export var money: PackedScene


func _ready():
	(health_component as HealthComponent).died.connect(on_died)
	
	

func on_died():
	if money == null or not owner is Node2D:
		return
	
	var current_modifier = MetaProgression.check_upgrade_lvl("money_drop")
	var adjusted_percent = drop_percent + (0.1 * current_modifier)
	
	var spawned = randf_range(0,1)
	if spawned <= adjusted_percent:
		var spawn_position = (owner as Node2D).global_position + Vector2(randf_range(-10,10),randf_range(-10,10))
		var money_instance = money.instantiate()
		var entites_layer = get_tree().get_first_node_in_group("entities_layer")
		entites_layer.add_child(money_instance)
		money_instance.global_position = spawn_position
	

