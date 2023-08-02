extends CharacterBody2D

const BASE_SPEED = 120
const ACCELERATION = 25
const MAX_HEALTH_RISE = 5

@onready var damage_timer:Timer = $DamageInterval
@onready var health_bar:ProgressBar = $HealthBar
@onready var health_component:HealthComponent = $HealthComponent
@onready var abilities:Node2D = $Abilities
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var velocity_component = $VelocityComponent

var qty_colliding_bodies = 0
var current_speed:float

func _ready():
	current_speed = velocity_component.max_speed
	GameEvents.new_ability_added.connect(on_new_ability_added)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func _process(delta):
	var move_vector = get_movement_vector()
	var direction = move_vector.normalized()
	var max_velocity = direction * current_speed
	
	velocity = velocity.lerp(max_velocity, 1 - exp(-delta * ACCELERATION))
	
	move_and_slide()
	if move_vector.x != 0 || move_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	var move_sign = sign(move_vector.x)
	if move_sign != 0:
		$Visuals.scale = Vector2(move_sign,1)
	
	update_health_bar()
	

func get_movement_vector():	
	var x_move = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_move = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	return Vector2(x_move,y_move)

func update_health_bar():
	health_bar.value = health_component.get_health_percent()

func check_and_deal_damage():
	if qty_colliding_bodies > 0 and damage_timer.is_stopped():
		health_component.damage(1)
		GameEvents.emit_player_damaged()
		damage_timer.start()

func _on_collision_area_body_entered(_body:Node2D):
	qty_colliding_bodies += 1
	check_and_deal_damage()

func _on_collision_area_body_exited(_body:Node2D):
	qty_colliding_bodies -= 1
	check_and_deal_damage()

func _on_damage_interval_timeout():
	check_and_deal_damage()

func on_new_ability_added(ability:Ability, _current_abilities:Dictionary):
	abilities.add_child(ability.ability_controller_scene.instantiate())

func on_ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.ability_type == "player":
		if upgrade.id == "max_health":
			health_component.rise_max_health(MAX_HEALTH_RISE)
		elif upgrade.id == "movement":
			current_speed = BASE_SPEED * (1 +(0.1 * current_upgrades["player"]["movement"]["level"]))
