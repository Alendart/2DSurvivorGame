extends Node

signal experience_vial_collected(number:float)
signal money_coin_collected(number:float)
signal money_spend(number:float)
signal ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary)
signal new_ability_added(ability:AbilityUpgrade, current_abilities:Array)
signal player_damaged
signal change_scene(path_to_scene:String)
signal save_slot_changed(slot_number: int)
signal save_slot_deleted(slot_number: int)

func emit_expierience_vial_collected(number:float):
	experience_vial_collected.emit(number)
	
func emit_money_coin_collected(number:float):
	money_coin_collected.emit(number)

func emit_money_spend(number:float):
	money_spend.emit(number)

func emit_ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)
	

func emit_new_ability_added(ability:Ability, current_abilities:Array):
	new_ability_added.emit(ability,current_abilities)
	

func emit_player_damaged():
	player_damaged.emit()
	

func emit_change_scene(path_to_scene:String):
	change_scene.emit(path_to_scene)

func emit_save_slot_changed(slot_number: int):
	save_slot_changed.emit(slot_number)

func emit_save_slot_deleted(slot_number: int):
	save_slot_deleted.emit(slot_number)
