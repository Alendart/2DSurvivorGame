extends CanvasLayer

signal transition_halfway

@onready var animation_player = $AnimationPlayer

func transition_in():
	$Fullsize.visible = true
	animation_player.play("in")
	await animation_player.animation_finished
	transition_halfway.emit()
	animation_player.play("out")
	await animation_player.animation_finished
	$Fullsize.visible = false



