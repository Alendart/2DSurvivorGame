extends Node

const LAST_ACTIVE_SAVE = "user://last.save"

const SAVE_FILE_PATHS = {
	1:"user://#1/game.save",
	2:"user://#2/game.save",
	3:"user://#3/game.save"
}

var save_info: Dictionary = {
	"save_slot":1,
	"occupaied":{
		1: true,
		2: false,
		3: false,
	}
	}

func _ready():
	DirAccess.make_dir_absolute("user://#1/")
	DirAccess.make_dir_absolute("user://#2/")
	DirAccess.make_dir_absolute("user://#3/")
	GameEvents.save_slot_changed.connect(update_active_slot)
	GameEvents.save_slot_deleted.connect(delete_save_slot)
	check_last_active_slot()

func save():
	var file = FileAccess.open(LAST_ACTIVE_SAVE, FileAccess.WRITE)
	file.store_var(save_info)

func update_active_slot(slot_number: int):
	if SAVE_FILE_PATHS.has(slot_number):
		save_info["save_slot"] = slot_number
		if save_info["occupaied"][slot_number] == false:
			save_info["occupaied"][slot_number] = true
		save()

func delete_save_slot(slot_number: int):
	if !save_info["occupaied"][slot_number]:
		return
	if SAVE_FILE_PATHS.has(slot_number):
		save_info["occupaied"][slot_number] = false
		MetaProgression.reset_save_to_default(SAVE_FILE_PATHS[slot_number])
		if save_info["save_slot"] == slot_number:
			GameEvents.emit_save_slot_changed(1)
		save()

func check_last_active_slot():
	if !FileAccess.file_exists(LAST_ACTIVE_SAVE):
		return
	var file = FileAccess.open(LAST_ACTIVE_SAVE, FileAccess.READ)
	save_info = file.get_var()

func get_actual_user_path():
	return SAVE_FILE_PATHS[save_info["save_slot"]]

func get_actual_user_number():
	return save_info["save_slot"]

func get_occupaied_slots_info():
	return save_info["occupaied"]
