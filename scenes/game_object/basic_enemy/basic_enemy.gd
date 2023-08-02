extends CharacterBody2D

const MAX_SPEED = 45

@onready var velocity_component:VelocityComponent = $VelocityComponent


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
#	var direction = get_direction_to_player()
#	velocity = direction * MAX_SPEED
#	move_and_slide()
#
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		$Visuals.scale = Vector2(move_sign,1)


func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		return (player.global_position - global_position).normalized()
	return Vector2.ZERO


