extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health:float = 10
var current_health
var regen_rate: float

func _ready():
	current_health = max_health
	$Timer.timeout.connect(on_timer_timeout)

func damage(dmg:float):
	current_health = max(current_health - dmg, 0)
	health_changed.emit()
	check_death.call_deferred()

func heal(value:float):
	current_health = min(current_health + value,max_health)

func rise_max_health(rise_value:float):
	max_health = max_health + rise_value
	current_health = max_health

func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)

func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()

func health_regeneration(value:float):
	if value > 0:
		regen_rate = value
		$Timer.start()

func on_timer_timeout():
	heal(regen_rate)
	$Timer.start()
