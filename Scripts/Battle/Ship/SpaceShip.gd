extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
const hit_on_shield_resource = preload("res://Scenes/Battle/Ship/ShieldHitted.tscn")

onready var animation : AnimationPlayer = $AnimationPlayer
onready var shield_barrier = $ShieldBarrier
onready var modules = $Weapons.get_children()

export(int, 1 ,4) var usable_modules
export(Array, PackedScene) var default_wpn_scenes

export(int) var max_shield = 2000
var shield setget setShield

export(int) var max_energy = 3500
var energy setget setEnergy

var equipped_weapon = null
var weapons = []
var actual_module

signal Shield_changed(value)
signal Energy_changed(value)

signal weapon_updated
signal module_changed
signal end_turn

func setShield(value):
	shield = clamp(value, 0, max_shield)
	emit_signal("Shield_changed", shield)
	
func setEnergy(value):
	energy = clamp(value, 0, max_energy)
	emit_signal("Energy_changed", energy)

func _ready():
	battle_units.SpaceShip = self
	actual_module = modules.front()
	initialize_default_weapons()
	
	$ShipUI/EnergyBar.initialize(max_energy)
	$ShipUI/ShieldBar.initialize(max_shield)
	self.energy = max_energy
	self.shield = max_shield
	#animation.play("Shield appear")

func attack(_enemy) -> void:
	if _enemy != null:
		equipped_weapon.shoot_to(_enemy)
		yield(equipped_weapon, "on_used")
		remove_wpn_child()
		yield(equipped_weapon, "tree_exited")
		if !(actual_module.get_index() < usable_modules -1 ):
			emit_signal("end_turn")
			$ShipUI/WeaponSelector.disappear()
			_change_wpn_module()
			return
		_change_wpn_module()
		add_wpn_child()
			

func pass_attack():
	remove_wpn_child()
	yield(equipped_weapon, "tree_exited")
	if !(actual_module.get_index() < usable_modules -1 ):
		emit_signal("end_turn")
		$ShipUI/WeaponSelector.disappear()
		_change_wpn_module()
		return
	_change_wpn_module()
	add_wpn_child()

func take_damage(amount, hit_position):
	if shield > 0:
		self.shield = shield - amount
		var hitOnShield = hit_on_shield_resource.instance()
		$ShieldBarrier.add_child(hitOnShield)
		hitOnShield.global_position = hit_position

func initialize_default_weapons():
	for i in range(5):
		var weapon_path = default_wpn_scenes[i]
		weapons.append(weapon_path.instance())

func initialize_turn():
	$ShipUI/WeaponSelector.appear()
	add_wpn_child()

func remove_wpn_child():
	var wpn_to_remove = equipped_weapon
	if not wpn_to_remove.is_empty:
		var wpnanim = wpn_to_remove.get_node("AnimationPlayer")
		wpnanim.play("rotdisappear")
	else:
		$Weapons.get_child(actual_module.get_index()).remove_child(wpn_to_remove)
	
func add_wpn_child():
	var wpn_to_equip = weapons.front()
	
	match actual_module.get_index():
		0:
			wpn_to_equip.set_scale(Vector2(1,1))
		1:
			wpn_to_equip.set_scale(Vector2(-1,1))
	
		2:
			wpn_to_equip.set_scale(Vector2(-1,-1))
	
		3:
			wpn_to_equip.set_scale(Vector2(1,-1))

	actual_module.add_child(wpn_to_equip)
	equipped_weapon = wpn_to_equip
	if not equipped_weapon.is_empty:
		var wpnanim = equipped_weapon.find_node("AnimationPlayer", true, false)
		yield(wpnanim, "animation_finished")
	else:
		print("perando")
		yield(get_tree().create_timer(3), "timeout")
	emit_signal("weapon_updated")
	$ShipUI/WeaponSelector.enable_use()

	
func _change_wpn_module(up:bool = true):
	if !up:
		modules.push_front(modules.back())
		modules.pop_back()
	else:
		modules.push_back(modules.front())
		modules.pop_front()
	actual_module = modules.front()

func _on_WeaponSelector_weapon_Changed():
	remove_wpn_child()
	add_wpn_child()
	print(actual_module.get_index())
	
func _exit_tree():
	battle_units.SpaceShip = null


