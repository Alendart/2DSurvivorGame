extends CharacterBody2D


@onready var velocity_component:VelocityComponent = $VelocityComponent

var move_vector = Vector2.ZERO
var is_moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$HurtBoxComponent.hit.connect(on_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_moving:
		if move_vector == Vector2.ZERO:
			move_vector = velocity_component.vector_to_player()
		velocity_component.accelerate_in_direction(move_vector)
	else:
		move_vector = Vector2.ZERO
		velocity_component.decelerate()
	
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		$Visuals.scale = Vector2(move_sign,1)


func set_is_moving(moving:bool):
	is_moving = moving
	
func on_hit():
	$RandomHitStreamPlayer2DComponent.play_random()
