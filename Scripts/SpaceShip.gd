extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

var max_shield = 2000
var shield = max_shield setget setShield

var max_energy = 3500
var energy = max_energy setget setEnergy

var equipped_weapon = null

const Weapons = [
	preload("res://Scenes/Weapons/Explosive Bullets.tscn"),
	preload("res://Scenes/Weapons/Shield Recover.tscn"),
	preload("res://Scenes/Weapons/Electro Cannon.tscn")
	]
	
signal Shield_Changed(value)
signal Energy_Changed(value)

func setShield(value):
	shield = clamp(value, 0, max_shield)
	emit_signal("Shield_Changed", shield)
	
func setEnergy(value):
	energy = clamp(value, 0, max_energy)
	emit_signal("Energy_Changed", energy)
	

func update_equipped_weapon(w_index):
	if find_node("Weapon", true, false) != null:
		remove_child(get_node("Weapon"))
		equipped_weapon = Weapons[w_index].instance()
		add_child(equipped_weapon)
	else:
		equipped_weapon = Weapons[w_index]
		add_child(equipped_weapon)

func _ready():
	update_equipped_weapon(0)
	battle_units.SpaceShip = self
	
	
func _exit_tree():
	battle_units.SpaceShip = null



