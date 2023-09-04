extends CharacterBody2D

@onready var health_bar = $HealthBar
@onready var health_component = $HealthComponent
@onready var velocity_component = $VelocityComponent

var is_moving:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	$HurtBoxComponent.hit.connect(on_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		$Visuals.scale = Vector2(move_sign,1)
	update_health_bar()

func update_health_bar():
	health_bar.value = health_component.get_health_percent()
	
func set_is_moving(moving:bool):
	is_moving = moving

func on_hit():
	$RandomHitStreamPlayer2DComponent.play_random()
