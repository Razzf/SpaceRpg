extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var animation : AnimationPlayer = $AnimationPlayer
var max_shield = 2000
var shield = max_shield setget setShield

var max_energy = 3500
var energy = max_energy setget setEnergy

var equipped_weapon = null
var equipped_weapon2 = null
var equipped_weapon3 = null
var equipped_weapon4 = null

const Weapons = [
	preload("res://Scenes/Weapons/Explosive Bullets.tscn"),
	preload("res://Scenes/Weapons/Shield Recover.tscn"),
	preload("res://Scenes/Weapons/Electro Cannon.tscn")
	]
	
signal Shield_Changed(value)
signal Energy_Changed(value)
signal weapon_used

func setShield(value):
	shield = clamp(value, 0, max_shield)
	emit_signal("Shield_Changed", shield)
	
func setEnergy(value):
	energy = clamp(value, 0, max_energy)
	emit_signal("Energy_Changed", energy)
	

func update_equipped_weapon(w_index) -> void:
	if find_node("Weapon", true, false) != null:
		var weapon = get_node("Weapon")
		remove_child(weapon)
		weapon.free()
		equipped_weapon = Weapons[w_index].instance()
		print(Weapons[w_index])
		add_child(equipped_weapon)
	else:
		equipped_weapon = Weapons[w_index]
		add_child(equipped_weapon)
		
func attack_enemy(_enemy) -> void:
	if _enemy != null:
		animation.play("attack")
		equipped_weapon.trigger_counter = 0
		equipped_weapon.add_child(equipped_weapon.shooting_scene.instance())
		_enemy.take_damage(equipped_weapon.power)
		self.energy -= equipped_weapon.energy_cost
		emit_signal("weapon_used")

func _ready():
	update_equipped_weapon(0)
	print(equipped_weapon._name)
	battle_units.SpaceShip = self
	
func _exit_tree():
	battle_units.SpaceShip = null
