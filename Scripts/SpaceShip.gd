extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

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
	

func update_equipped_weapon(w_index):
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
		
func attack_enemy(_enemy):
	if _enemy != null:
		var explosion1 = equipped_weapon.explosion.instance()
		var explosion2 = equipped_weapon.explosion.instance()
		var explosion3 = equipped_weapon.explosion.instance()
		var explosion4 = equipped_weapon.explosion.instance()
		var explosion5 = equipped_weapon.explosion.instance()
		_enemy.add_child(explosion1)
		explosion1.global_position = Vector2(80,80)
		yield(get_tree().create_timer(.2),"timeout")
		_enemy.add_child(explosion2)
		explosion2.global_position = Vector2(95,95)
		yield(get_tree().create_timer(.2),"timeout")
		_enemy.add_child(explosion3)
		explosion3.global_position = Vector2(120,120)
		yield(get_tree().create_timer(.2),"timeout")
		_enemy.add_child(explosion4)
		explosion4.global_position = Vector2(80,135)
		yield(get_tree().create_timer(.2),"timeout")
		_enemy.add_child(explosion5)
		explosion5.global_position = Vector2(60,120)
		yield(get_tree().create_timer(.2),"timeout")
		
		
		
		
		
		_enemy.take_damage(equipped_weapon.power)
		self.energy -= equipped_weapon.energy_cost
		emit_signal("weapon_used")

func _ready():
	update_equipped_weapon(0)
	print(equipped_weapon)
	battle_units.SpaceShip = self
	
func _exit_tree():
	battle_units.SpaceShip = null
