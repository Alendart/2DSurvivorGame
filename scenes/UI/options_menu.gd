extends CanvasLayer

signal options_quited

@onready var global_slider = %GlobalSlider
@onready var sfx_slider = %SFXSlider
@onready var music_slider = %MusicSlider
@onready var window_mode_button = %WindowModeButton
@onready var back_button = %BackButton


func _ready():
	global_slider.value_changed.connect(on_slider_change.bind("Master"))
	sfx_slider.value_changed.connect(on_slider_change.bind("sfx"))
	music_slider.value_changed.connect(on_slider_change.bind("music"))
	window_mode_button.pressed.connect(on_window_mode_pressed)
	back_button.pressed.connect(on_back_button_pressed)
	check_window_mode_text()
	update_sliders()


func check_window_mode_text():
	var mode = DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_mode_button.text = "Enable"
	else:
		window_mode_button.text = "Disable"
		


func get_bus_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume)

func set_bus_volume(bus_name: String, value: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))

func update_sliders():
	global_slider.value = get_bus_volume_percent("Master")
	sfx_slider.value = get_bus_volume_percent("sfx")
	music_slider.value = get_bus_volume_percent("music")

func on_slider_change(value:float, bus_name:String):
	set_bus_volume(bus_name,value)

func on_window_mode_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	check_window_mode_text()

func on_back_button_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transition_halfway
	options_quited.emit()
