extends Node

signal experience_vial_collected(number:float)
signal ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary)
signal new_ability_added(ability:AbilityUpgrade, current_abilities:Array)
signal player_damaged

func emit_expierience_vial_collected(number:float):
	experience_vial_collected.emit(number)
	

func emit_ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)
	

func emit_new_ability_added(ability:Ability, current_abilities:Array):
	new_ability_added.emit(ability,current_abilities)
	

func emit_player_damaged():
	player_damaged.emit()
