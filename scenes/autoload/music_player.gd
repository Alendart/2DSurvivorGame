extends AudioStreamPlayer

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	finished.connect(on_finished)
	timer.timeout.connect(on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_finished():
	timer.start()
	

func on_timer_timeout():
	play()
	

