extends Node

const SAVE_FILE_PATH = "user://game.save"

var save_data: Dictionary = {
	"win_count":0,
	"loss_count":0,
	"meta_upgrade_currency":0,
	"meta_upgrades":{}
	}

func _ready():
	GameEvents.money_coin_collected.connect(on_money_coin_collected)
	load_saved_files()
	
	

func save_files():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)

func load_saved_files():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
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
