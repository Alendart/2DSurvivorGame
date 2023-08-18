extends CanvasLayer


func _ready():
	%PlayButton.pressed.connect(on_play_pressed)
	%OptionButton.pressed.connect(on_option_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	


func on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Main/main.tscn")

func on_option_pressed():
	pass

func on_quit_pressed():
	get_tree().quit()


