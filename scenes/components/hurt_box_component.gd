extends Area2D
class_name HurtBoxComponent

signal hit

@export var health_component:HealthComponent

var floating_text_scene:PackedScene = preload("res://scenes/UI/floating_text.tscn")

func _ready():
	area_entered.connect(on_area_entered)
	

func on_area_entered(other_area: Area2D):
	if not other_area is HitBoxComponent or health_component == null:
		return
	
	var hitbox = other_area as HitBoxComponent
	health_component.damage(hitbox.damage)
	
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position + (Vector2.UP * 16)
	floating_text.start(str(hitbox.damage))
	
	hit.emit()
