extends CanvasLayer

@export var save_box_scene: PackedScene

@onready var v_box_container = %VBoxContainer

var active_slot = 0
var occupaied_slots: Dictionary

func _ready():
	active_slot = SaveSlotManager.get_actual_user_number()
	occupaied_slots = SaveSlotManager.get_occupaied_slots_info()
	display_save_slots()
 
func display_save_slots():
	var index = 1
	for i in 3:
		var save_box_instance = save_box_scene.instantiate()
		v_box_container.add_child(save_box_instance)
		save_box_instance.slot_num = index
		save_box_instance.active = index == active_slot
		save_box_instance.occupaied = occupaied_slots[index]
		save_box_instance.update_save_box_display()
		index += 1


