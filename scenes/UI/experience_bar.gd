extends CanvasLayer

@export var experience_manager:Node
@onready var progress_bar = $MarginContainer/ProgressBar
@onready var label = $MarginContainer/MarginContainer/Label

func _ready():
	experience_manager.expierence_updated.connect(on_experience_updated)
	

func on_experience_updated(curr_exp:float, full_exp:float, curr_lvl:int):
	progress_bar.value = curr_exp / full_exp
	label.text = "Level:" + str(curr_lvl)
