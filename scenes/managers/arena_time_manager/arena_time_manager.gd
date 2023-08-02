extends Node

const DIFFICULTY_INTERVAL = 5

signal rise_difficulty(level:int)

@export var end_screen:PackedScene
@onready var timer = $Timer

var arena_difficulty = 0



func _process(_delta):
	var next_level_time = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	difficulty_counter(next_level_time)

func get_time_elapsed():
	return timer.wait_time - timer.time_left
	



func _on_timer_timeout():
	var end_screen_instance = end_screen.instantiate()
	add_child(end_screen_instance)
	

func difficulty_counter(time:float):
	if timer.time_left <= time:
		arena_difficulty +=1
		rise_difficulty.emit(arena_difficulty)
		print("Aktualny poziom ", arena_difficulty)

