extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health:float = 10
var current_health

func _ready():
	current_health = max_health

func damage(dmg:float):
	current_health = max(current_health - dmg, 0)
	health_changed.emit()
	check_death.call_deferred()

func heal(value:float):
	pass

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
