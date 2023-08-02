extends CanvasLayer

@export var arena_time_manager: Node
@onready var label = %Label

func _process(_delta):
	if arena_time_manager == null or label == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	var minutes = floor(time_elapsed/60)
	var seconds = time_elapsed - minutes * 60
	label.text =str(minutes) + ":" + "%02d" % snapped(seconds, 0.1)
