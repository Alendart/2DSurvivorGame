extends Node

var base_save_data: Dictionary = {
	"win_count":0,
	"loss_count":0,
	"meta_upgrade_currency":0,
	"meta_upgrades":{}
	}

var save_data: Dictionary = {
	"win_count":0,
	"loss_count":0,
	"meta_upgrade_currency":0,
	"meta_upgrades":{}
	}

var active_user_save_path: String

func _ready():
	GameEvents.money_coin_collected.connect(on_money_coin_collected)
	GameEvents.save_slot_changed.connect(on_save_slot_changed)
	active_user_save_path = SaveSlotManager.get_actual_user_path()
	load_saved_files()
	

func on_save_slot_changed(slot_number: int):
	active_user_save_path = SaveSlotManager.get_actual_user_path()
	load_saved_files()
	GameEvents.emit_money_coin_collected(save_data["meta_upgrade_currency"])

func reset_save_to_default(slot_path: String):
	var save = active_user_save_path
	active_user_save_path = slot_path
	save_data = base_save_data
	save_files()
	active_user_save_path = save

func save_files():
	var file = FileAccess.open(active_user_save_path, FileAccess.WRITE)
	file.store_var(save_data)

func load_saved_files():
	if !FileAccess.file_exists(active_user_save_path):
		return
	var file = FileAccess.open(active_user_save_path, FileAccess.READ)
	save_data = file.get_var()

func add_meta_upgrade(upgrade: MetaUpgrade):
	if !save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"lvl": 0
		}
	
	save_data["meta_upgrades"][upgrade.id]["lvl"] += 1
	save_files()

func check_upgrade_lvl(upgrade_id: String):
	if save_data["meta_upgrades"].has(upgrade_id):
		return save_data["meta_upgrades"][upgrade_id]["lvl"]
	return 0

func on_money_coin_collected(number: float):
	if number == null:
		return
	if number == save_data["meta_upgrade_currency"] and number > 1:
		return
	save_data["meta_upgrade_currency"] += number
