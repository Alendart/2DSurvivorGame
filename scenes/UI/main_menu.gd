extends CanvasLayer

@export var options_scene: PackedScene

func _ready():
	%PlayButton.pressed.connect(on_play_pressed)
	%OptionButton.pressed.connect(on_option_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	


func on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Main/main.tscn")

func on_option_pressed():
	var options = options_scene.instantiate()
	add_child(options)
	options.options_quited.connect(on_options_quited.bind(options))
	

func on_quit_pressed():
	get_tree().quit()

func on_options_quited(options:Node):
	options.queue_free()

