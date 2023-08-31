extends Node


func _ready():
	GameEvents.change_scene.connect(on_change_scene)


func on_change_scene(path_to_scene: String):
	for child in get_children():
		remove_child(child)
		child.queue_free()
	var new_scene = load(path_to_scene).instantiate()
	add_child(new_scene)
