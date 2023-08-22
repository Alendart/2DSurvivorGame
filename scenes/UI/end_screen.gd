extends CanvasLayer

@onready var title_label: Label = %TitleLabel
@onready var desc_label: Label = %DescriptionLabel
@onready var panel_container = %PanelContainer


func _ready():
	panel_container.pivot_offset = panel_container.size / 2 
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	MetaProgression.save_files()
	get_tree().paused = true
	
	%Continue.pressed.connect(on_continue_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)


func set_defeat():
	title_label.text = "Defeat"
	desc_label.text = "You lost!"
	play_sound(true)

func play_sound(defeat:bool = false):
	if defeat:
		$LooseStreamPlayer.play()
	else:
		$VicotryStreamPlayer.play()

func on_continue_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transition_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/meta_upgrade_menu.tscn")


func on_quit_button_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transition_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
