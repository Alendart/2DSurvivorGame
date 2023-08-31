extends CanvasLayer

@export var option_scene:PackedScene

@onready var panel_container = $MarginContainer/PanelContainer
var is_closing:bool = false

func _ready():
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	%ResumeButton.pressed.connect(on_resume_pressed)
	%OptionButton.pressed.connect(on_option_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	
	
	$AnimationPlayer.play("default")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func close_menu():
	if !is_closing:
		is_closing = true
		$AnimationPlayer.play_backwards("default")
	
		var tween = create_tween()
		tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
		tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
		await tween.finished
		get_tree().paused = false
		queue_free()


func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		close_menu()
		get_tree().root.set_input_as_handled()

func on_resume_pressed():
	close_menu()

func on_option_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transition_halfway
	var options = option_scene.instantiate()
	add_child(options)
	options.options_quited.connect(on_options_quited.bind(options))

func on_quit_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transition_halfway
	get_tree().paused = false
	GameEvents.emit_change_scene("res://scenes/UI/main_menu.tscn")
#	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")

func on_options_quited(options:Node):
	options.queue_free()
