extends PanelContainer

@onready var save_slot = %SaveSlot
@onready var delete_button = $VBoxContainer/SaveBoxButtonContainer/DeleteButton
@onready var choose_button = $VBoxContainer/SaveBoxButtonContainer/ChooseButton
@onready var save_header = %SaveHeader

var active = false
var occupaied = false
var active_color = Color(0.90980392694473, 0.27058824896812, 0.21568627655506)

var slot_num: int

func _ready():
	GameEvents.save_slot_changed.connect(on_save_slot_changed)
	GameEvents.save_slot_deleted.connect(on_save_slot_deleted)
	delete_button.pressed.connect(on_delete_pressed)
	choose_button.pressed.connect(on_choose_pressed)
	
func on_save_slot_changed(number: int):
	if slot_num == number:
		active = true
		occupaied = true
	else:
		active = false
	update_save_box_display()

func on_save_slot_deleted(number: int):
	pass


func on_choose_pressed():
	GameEvents.emit_save_slot_changed(slot_num)

func on_delete_pressed():
	active = false
	occupaied = false
	update_save_box_display()
	GameEvents.emit_save_slot_deleted(slot_num)

func update_save_box_display():
	save_header.text = "Save slot #%d" % slot_num
	choose_button.disabled = active
	if active:
		save_slot.add_theme_color_override("font_color",active_color)
	else:
		save_slot.remove_theme_color_override("font_color")
	delete_button.disabled = !occupaied
	if !occupaied:
		save_slot.text = "Empty"
	else:
		save_slot.text = "Player no: %d" % slot_num
	
