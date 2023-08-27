extends Node2D
class_name SpearAbility

const MAX_RANGE = 100

@onready var hitbox:HitBoxComponent = $HitBoxComponent
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $HitBoxComponent/CollisionShape2D


var base_rotation = Vector2.RIGHT

func _ready():
	collision_shape_2d.disabled = true
	
	


func make_attack():
	print("Rozpoczynam atak")
	var enemies_list = get_tree().get_nodes_in_group("enemy")
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null or enemies_list.size() == 0:
		return
	var enemies_in_range = enemies_list.filter(func(enemy:Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE,2)
	)
	if enemies_in_range.size() == 0:
		return
	
	enemies_in_range.sort_custom(func(a:Node2D,b:Node2D):
		return a.global_position.distance_squared_to(player.global_position) < b.global_position.distance_squared_to(player.global_position)
	)
	
	var enemy_to_hit = enemies_in_range[0]
	print("Powinna się dziać animacja")
	var tween = create_tween()
	global_position = player.global_position
	rotation = (enemy_to_hit.global_position - player.global_position).angle() + deg_to_rad(90)
	
	var pull_position = ((player.global_position - enemy_to_hit.global_position) + player.global_position)
	var finnish_position = ((enemy_to_hit.global_position - player.global_position) + player.global_position)
	tween.tween_property(sprite_2d,"scale",Vector2.ZERO,0.01)
	tween.tween_property(sprite_2d,"scale",Vector2(1.5,1.5),0.1)
	tween.tween_property(self,"position",pull_position,0.2)
	tween.tween_property(self,"position",finnish_position,0.3).set_delay(0.2)
	
	print("Wszystko zrobione")
	

