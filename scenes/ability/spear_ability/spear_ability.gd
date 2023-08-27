extends Node2D
class_name SpearAbility

const MAX_RANGE = 100

@onready var hitbox:HitBoxComponent = $HitBoxComponent
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $HitBoxComponent/CollisionShape2D


var base_rotation = Vector2.RIGHT

func _ready():
	pass
	
	


func make_attack(enemies_in_range:Array, attack_qty:int):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null or enemies_in_range.size() == 0:
		return
	
	var enemy_to_hit = enemies_in_range[0]
	var tween = create_tween()
	global_position = player.global_position
	rotation = (enemy_to_hit.global_position - player.global_position).angle() + deg_to_rad(90)
	
	var pull_vector = (player.global_position - enemy_to_hit.global_position).normalized() * 20
	var pull_position = pull_vector + player.global_position
	var finish_vector = (enemy_to_hit.global_position - player.global_position).normalized() * 50
	var finnish_position = finish_vector + player.global_position
	
	tween.tween_property(sprite_2d,"scale",Vector2.ZERO,0.01)
	tween.parallel().tween_property(collision_shape_2d,"disabled",true,0.01)
	tween.tween_property(sprite_2d,"scale",Vector2(1.5,1.5),0.1)
	tween.tween_property(self,"position",pull_position,0.2)
	tween.tween_property(self,"position",finnish_position,0.3).set_delay(0.2)
	tween.parallel().tween_property(collision_shape_2d,"disabled",false,0.01).set_delay(0.2)
	tween.tween_property(collision_shape_2d,"disabled",true,0.01)
	tween.tween_property(sprite_2d,"scale",Vector2.ZERO,0.1)
	tween.tween_callback(queue_free)
	

