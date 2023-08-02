extends Node

signal expierence_updated(curr_exp:float, full_exp:float, curr_lvl:int)
signal level_up(lvl:int)

var current_experience = 0
var current_level = 1
var experience_full_bar = 5
var experience_progress_multiply = 10

func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)
	

func increment_experience(number:float):
	current_experience += number
	if current_experience >= experience_full_bar:
		current_level +=1
		level_up.emit(current_level)
		experience_full_bar = current_level * experience_progress_multiply
		current_experience = 0
	expierence_updated.emit(current_experience,experience_full_bar,current_level)
	

func on_experience_vial_collected(number:float):
	increment_experience(number)
