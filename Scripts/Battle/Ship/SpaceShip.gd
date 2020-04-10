extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var animation : AnimationPlayer = $AnimationPlayer
onready var shield_barrier = $ShieldBarrier

export(int, 1 ,4) var usable_modules
export(Array, PackedScene) var weapons
var equipped_weapon = null

export(int) var max_shield = 2000
var shield setget setShield

var module_idx = 0 setget setModule_idx

export(int) var max_energy = 3500
var energy setget setEnergy




signal end_turn

var load_scene = preload("res://Scenes/Battle/Control/WeaponSelector.tscn")
const hit_on_shield_resource = preload("res://Scenes/Battle/Ship/ShieldHitted.tscn")

	
signal Shield_changed(value)
signal Energy_changed(value)

func setModule_idx(value):
	module_idx = value

func setShield(value):
	shield = clamp(value, 0, max_shield)
	emit_signal("Shield_changed", shield)
	
func setEnergy(value):
	energy = clamp(value, 0, max_energy)
	emit_signal("Energy_changed", energy)
	
func update_equipped_weapon(w_index) -> void:
	if equipped_weapon != null:
		var wpnanim = equipped_weapon.get_node("AnimationPlayer")
		wpnanim.play("rotdisappear")
		var temp_wpn = weapons[w_index].instance()
		if module_idx == 1:
			temp_wpn.set_scale(Vector2(-1,1))
		elif module_idx == 2:
			temp_wpn.set_scale(Vector2(-1,-1))
		elif module_idx == 3:
			temp_wpn.set_scale(Vector2(1,-1))
		$Weapons.get_child(module_idx).add_child(temp_wpn)
		equipped_weapon = self.get_node("Weapons").get_child(module_idx).get_child(1)

	else:
		var temp_wpn = weapons[w_index].instance()
		if module_idx == 1:
			temp_wpn.set_scale(Vector2(-1,1))
		elif module_idx == 2:
			temp_wpn.set_scale(Vector2(-1,-1))
		elif module_idx == 3:
			temp_wpn.set_scale(Vector2(1,-1))
		$Weapons.get_child(module_idx).add_child(temp_wpn)
		equipped_weapon = self.get_node("Weapons").get_child(module_idx).get_child(0)

		
#func attack(_enemy) -> void:
#
#	if module_idx < usable_modules-1:
#		if _enemy != null:
#			equipped_weapon.shoot_to(_enemy)
#			yield(equipped_weapon, "on_used")		
#			var wpnanim = equipped_weapon.get_node("AnimationPlayer")
#			#wpnanim.play_backwards("appear")
#			#yield(equipped_weapon, "tree_exiting")
#			equipped_weapon = null
#			module_idx = module_idx + 1
#			actual_module = modules[module_idx]
#			var wpnselector = load_scene.instance()
#			get_parent().get_node("MainControl").add_child(wpnselector)
#	else:
#		if _enemy != null:
#			equipped_weapon.shoot_to(_enemy)
#			yield(equipped_weapon, "on_used")
#			var wpnanim = equipped_weapon.get_node("AnimationPlayer")
#			wpnanim.play_backwards("appear")
#			equipped_weapon = null
#			emit_signal("end_turn")
#
#			module_idx = 0
#			actual_module = modules[module_idx]
#
#func wea():
#	if module_idx < usable_modules-1:
#		var wpnanim = equipped_weapon.get_node("AnimationPlayer")
#		wpnanim.play_backwards("appear")
#		yield(equipped_weapon, "tree_exiting")
#		equipped_weapon = null
#		module_idx = module_idx + 1
#		actual_module = modules[module_idx]
#		var wpnselector = load_scene.instance()
#		get_parent().get_node("MainControl").add_child(wpnselector)
#	else:
#		var wpnanim = equipped_weapon.get_node("AnimationPlayer")
#		wpnanim.play_backwards("appear")
#		equipped_weapon = null
#		emit_signal("end_turn")
#		module_idx = 0
#		actual_module = modules[module_idx]
#

func take_damage(amount, hit_position):
	if shield > 0:
		self.shield = shield - amount
		var hitOnShield = hit_on_shield_resource.instance()
		$ShieldBarrier.add_child(hitOnShield)
		hitOnShield.global_position = hit_position


func _ready():
	battle_units.SpaceShip = self
	$EnergyBar.initialize(max_energy)
	$ShieldBar.initialize(max_shield)
	self.energy = max_energy
	self.shield = max_shield
	animation.play("Shield appear")
	yield(get_tree().create_timer(2), "timeout")
	for i in range(usable_modules):
		var weapon_to_add = weapons.front().instance()
		if i == 1:
			weapon_to_add.set_scale(Vector2(-1,1))
		elif i == 2:
			weapon_to_add.set_scale(Vector2(-1,-1))
		elif i == 3:
			weapon_to_add.set_scale(Vector2(1,-1))
		$Weapons.get_child(i).add_child(weapon_to_add)
	equipped_weapon = $Weapons/WpnPos1.get_node("Weapon")
		
		
	
func _exit_tree():
	battle_units.SpaceShip = null
	

