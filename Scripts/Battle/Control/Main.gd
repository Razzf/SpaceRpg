extends Control

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

	
func _ready():
	battle_units.BattleUI = self
	
func _exit_tree():
	battle_units.BattleUI = null
