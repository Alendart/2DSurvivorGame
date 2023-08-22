extends Node
class_name VialDropComponent

@export_range(0,1) var drop_percent: float = 0.5 
@export var health_component: Node
@export var vial: PackedScene


func _ready():
	(health_component as HealthComponent).died.connect(on_died)
	

func on_died():
	if vial == null or not owner is Node2D:
		return
	
	var current_modifier = MetaProgression.check_upgrade_lvl("experience_gain")
	var adjusted_percent = drop_percent + (0.1 * current_modifier)
	
	var spawned = randf_range(0,1)
	if spawned <= adjusted_percent:
		var spawn_position = (owner as Node2D).global_position
		var vial_instance = vial.instantiate()
		var entites_layer = get_tree().get_first_node_in_group("entities_layer")
		entites_layer.add_child(vial_instance)
		vial_instance.global_position = spawn_position
	






