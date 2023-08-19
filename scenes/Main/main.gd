extends Node2D

@export var end_screen:PackedScene

var pause_menu = preload("res://scenes/UI/pause_menu.tscn")

func _ready():
	%Player.health_component.died.connect(on_player_died)
	$ExpierienceManager.level_up.emit(1)
	

func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		add_child(pause_menu.instantiate())
		get_tree().root.set_input_as_handled()

func on_player_died():
	var end_screen_instance = end_screen.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
