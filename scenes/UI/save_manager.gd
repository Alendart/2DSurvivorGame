extends CanvasLayer

@onready var save_box = $MarginContainer/MarginContainer/VBoxContainer/SaveBox
@onready var save_box_2 = $MarginContainer/MarginContainer/VBoxContainer/SaveBox2
@onready var save_box_3 = $MarginContainer/MarginContainer/VBoxContainer/SaveBox3

var active_slots = 0


func _ready():
	GameEvents.save_path_changed.connect(on_save_changed)


func on_save_changed(path: String):
	pass
 

