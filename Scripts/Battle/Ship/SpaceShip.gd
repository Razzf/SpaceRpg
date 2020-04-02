extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var animation : AnimationPlayer = $AnimationPlayer
onready var shield_barrier = $ShieldBarrier

var max_shield = 2000
var shield setget setShield

var max_energy = 3500
var energy setget setEnergy

var equipped_weapon = null

signal end_turn

const hit_on_shield_resource = preload("res://Scenes/Battle/Ship/ShieldHitted.tscn")

const Weapons = [
	preload("res://Scenes/Battle/Ship/Weapons/BlueSparks.tscn"),
	preload("res://Scenes/Battle/Ship/Weapons/BurningLaser.tscn"),
	preload("res://Scenes/Battle/Ship/Weapons/BlastingCannon.tscn"),
	preload("res://Scenes/Battle/Ship/Weapons/ShieldRecover.tscn"),
	preload("res://Scenes/Battle/Ship/Weapons/ElectroCannon.tscn"),
	]
	
signal Shield_Changed(value)
signal Energy_Changed(value)

func setShield(value):
	shield = clamp(value, 0, max_shield)
	emit_signal("Shield_Changed", shield)
	
func setEnergy(value):
	energy = clamp(value, 0, max_energy)
	emit_signal("Energy_Changed", energy)
	
func update_equipped_weapon(w_index) -> void:
	if equipped_weapon != null:
		var wpnanim = equipped_weapon.get_node("AnimationPlayer")
		wpnanim.play("rotdisappear")
		$Modules/Position2D.add_child(Weapons[w_index].instance())
		equipped_weapon = self.get_node("Modules/Position2D").get_child(1)
	else:
		$Modules/Position2D.add_child(Weapons[w_index].instance())
		equipped_weapon = self.get_node("Modules/Position2D/Weapon")
		
		
func attack(_enemy) -> void:
	if _enemy != null:
		equipped_weapon.shoot_to(_enemy)
		yield(equipped_weapon, "on_used")
		emit_signal("end_turn")
		

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
	energy = max_energy
	shield = max_shield
	battle_units.Enemy.hp = battle_units.Enemy.max_hp
	emit_signal("Energy_Changed", energy)
	emit_signal("Shield_Changed",shield)
	animation.play("Shield appear")
	
func _exit_tree():
	battle_units.SpaceShip = null
	
