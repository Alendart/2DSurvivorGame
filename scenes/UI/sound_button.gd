extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_pressed():
	$RandomAudioStreamComponent.play_random()
