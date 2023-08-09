extends Node2D

@export var health_component: Node
@export var sprite:Sprite2D

func _ready():
	$GPUParticles2D.texture = sprite.texture
	health_component.died.connect(on_died)
	


func on_died():
	var entites = get_tree().get_first_node_in_group("entities_layer")
	var death_animation = self
	var self_position = self.global_position
	get_parent().remove_child(self)
	entites.add_child(death_animation)
	death_animation.global_position = self_position
	
	$AnimationPlayer.play("default")
	$RandomStreamPlayer2DComponent.play_random()
	
