extends CanvasLayer

@export var options_scene: PackedScene
@export var meta_upgrade_menu: PackedScene

func _ready():
	%PlayButton.pressed.connect(on_play_pressed)
	%OptionButton.pressed.connect(on_option_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	%UpgradeButton.pressed.connect(on_upgrade_pressed)

func on_play_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transition_halfway
	GameEvents.emit_change_scene("res://scenes/Main/main.tscn")
#	get_tree().change_scene_to_file("res://scenes/Main/main.tscn")

func on_option_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transition_halfway
	var options = options_scene.instantiate()
	add_child(options)
	options.options_quited.connect(on_options_quited.bind(options))
	

func on_quit_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transition_halfway
	get_tree().quit()

func on_options_quited(options:Node):
	options.queue_free()

func on_upgrade_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transition_halfway
	GameEvents.emit_change_scene("res://scenes/UI/meta_upgrade_menu.tscn")
#	get_tree().change_scene_to_file("res://scenes/UI/meta_upgrade_menu.tscn")

