extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

var max_shield = 2000
var shield = max_shield setget setShield

var max_energy = 3500
var energy = max_energy setget setEnergy

var max_ap = 6
var ap = max_ap setget setAp

signal Shield_Changed(value)
signal Energy_Changed(value)
signal Ap_Changed(value)
signal end_turn

func setShield(value):
	shield = clamp(value, 0, max_shield)
	emit_signal("Shield_Changed", shield)
	
func setEnergy(value):
	energy = clamp(value, 0, max_energy)
	emit_signal("Energy_Changed", energy)
	
func setAp(value):
	ap = clamp(value, 0, max_ap)
	emit_signal("Ap_Changed", ap)
	if ap == 0:
		emit_signal("end_turn")

func _ready():
	battle_units.ShipStats = self
	
func _exit_tree():
	battle_units.ShipStats = null
