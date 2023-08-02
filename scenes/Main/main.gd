extends Node2D

@export var end_screen:PackedScene

func _ready():
	%Player.health_component.died.connect(on_player_died)
	$ExpierienceManager.level_up.emit(1)
	

func on_player_died():
	var end_screen_instance = end_screen.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
