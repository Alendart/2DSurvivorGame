extends Node2D
class_name SpearAbility

const MAX_RANGE = 100

@onready var hitbox:HitBoxComponent = $HitBoxComponent
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $HitBoxComponent/CollisionShape2D


var pull_move = 20
var attack_move = 50
var base_size = Vector2.ONE

func _ready():
	pass
	
	


func make_attack(enemies_in_range:Array, attack_number:int, size_modifier:int, length_modifier:float):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null or enemies_in_range.size() == 0:
		return
	
	var actual_attack_move = 50 * (1+length_modifier)
	var actual_size = base_size + (size_modifier * Vector2(0.25,0.25))
	
	var enemy_to_hit = enemies_in_range[0]
	var tween = create_tween()
	rotation = (enemy_to_hit.global_position - player.global_position).angle() + deg_to_rad(90)
	
	var base_vector = (enemy_to_hit.global_position - player.global_position).normalized() as Vector2
	var position_adjust_vector = Vector2.ZERO 
	
	if attack_number == 0:
		pass
	if attack_number == 1:
		position_adjust_vector = base_vector.from_angle(deg_to_rad(90)) * 25
	if attack_number == 2:
		position_adjust_vector = base_vector.from_angle(deg_to_rad(-90)) * 25
	
	global_position = player.global_position + position_adjust_vector
	
	var pull_vector = (global_position - (enemy_to_hit.global_position + position_adjust_vector)).normalized() as Vector2
	var finish_vector = ((enemy_to_hit.global_position + position_adjust_vector) - global_position).normalized() as Vector2
	
	var pull_position = pull_vector * pull_move + global_position
	var finish_position = finish_vector * actual_attack_move + global_position
	
	tween.tween_property(self,"scale",Vector2.ZERO,0.01)
	tween.parallel().tween_property(collision_shape_2d,"disabled",true,0.01)
	tween.tween_property(self,"scale",actual_size,0.1)
	tween.tween_property(self,"position",pull_position,0.2)
	tween.tween_property(self,"position",finish_position,0.3).set_delay(0.2)
	tween.parallel().tween_property(collision_shape_2d,"disabled",false,0.01).set_delay(0.2)
	tween.tween_property(collision_shape_2d,"disabled",true,0.01)
	tween.tween_property(self,"scale",Vector2.ZERO,0.1)
	tween.tween_callback(queue_free)
	

