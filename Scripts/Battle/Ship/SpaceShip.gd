extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var animation : AnimationPlayer = $AnimationPlayer
onready var shield_barrier = $ShieldBarrier

export(int, 1 ,4) var usable_modules
export(Array, PackedScene) var module_1
export(Array, PackedScene) var module_2
export(Array, PackedScene) var module_3
export(Array, PackedScene) var module_4

onready var modules = [module_1, module_2, module_3, module_4]
onready var actual_module = modules[0]
export(int) var max_shield = 2000
var shield setget setShield

var module_idx = 0 setget setModule_idx

export(int) var max_energy = 3500
var energy setget setEnergy

var equipped_weapon = null

signal end_turn

var load_scene = preload("res://Scenes/Battle/Control/WeaponSelector.tscn")
const hit_on_shield_resource = preload("res://Scenes/Battle/Ship/ShieldHitted.tscn")

	
signal Shield_Changed(value)
signal Energy_Changed(value)

func setModule_idx(value):
	module_idx = value
#	if module_idx == usable_modules:
#		print("out of range")
#		var wpnanim = equipped_weapon.get_node("AnimationPlayer")
#		wpnanim.play("rotdisappear")
#		emit_signal("end_turn")
#		module_idx = 0
#		actual_module = modules[module_idx]

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
		var temp_wpn = actual_module[w_index].instance()
		if module_idx == 1:
			#temp_wpn.get_node("Sprite").set_flip_h(true)
			temp_wpn.get_node("Sprite").set_scale(Vector2(-1,1))
		elif module_idx == 2:
#			temp_wpn.get_node("Sprite").set_flip_h(true)
#			temp_wpn.get_node("Sprite").set_flip_v(true)
			temp_wpn.get_node("Sprite").set_scale(Vector2(-1,-1))
		elif module_idx == 3:
			#temp_wpn.get_node("Sprite").set_flip_v(true)
			temp_wpn.get_node("Sprite").set_scale(Vector2(1,-1))
		$Modules.get_child(module_idx).add_child(temp_wpn)
		#$Modules/Position2D.add_child(Weapons[w_index].instance())
		equipped_weapon = self.get_node("Modules").get_child(module_idx).get_child(1)

	else:
		print(actual_module)
		var temp_wpn = actual_module[w_index].instance()
		if module_idx == 1:
			#temp_wpn.get_node("Sprite").set_flip_h(true)
			temp_wpn.get_node("Sprite").set_scale(Vector2(-1,1))
		elif module_idx == 2:
#			temp_wpn.get_node("Sprite").set_flip_h(true)
#			temp_wpn.get_node("Sprite").set_flip_v(true)
			temp_wpn.get_node("Sprite").set_scale(Vector2(-1,-1))
		elif module_idx == 3:
			#temp_wpn.get_node("Sprite").set_flip_v(true)
			temp_wpn.get_node("Sprite").set_scale(Vector2(1,-1))
		$Modules.get_child(module_idx).add_child(temp_wpn)
		equipped_weapon = self.get_node("Modules").get_child(module_idx).get_child(0)
		print("esta es el arma equipada", equipped_weapon)
		
		
func attack(_enemy) -> void:
	
	if module_idx < usable_modules-1:
		if _enemy != null:
			equipped_weapon.shoot_to(_enemy)
			yield(equipped_weapon, "on_used")		
			var wpnanim = equipped_weapon.get_node("AnimationPlayer")
			wpnanim.play("rotdisappear")
			yield(equipped_weapon, "tree_exiting")
			equipped_weapon = null
			module_idx = module_idx + 1
			actual_module = modules[module_idx]
			print("the actual module is:", actual_module)
			var wpnselector = load_scene.instance()
			get_parent().get_node("MainControl").add_child(wpnselector)
	else:
		if _enemy != null:
			equipped_weapon.shoot_to(_enemy)
			yield(equipped_weapon, "on_used")
			var wpnanim = equipped_weapon.get_node("AnimationPlayer")
			wpnanim.play("rotdisappear")
			equipped_weapon = null
			emit_signal("end_turn")
			
			module_idx = 0
			actual_module = modules[module_idx]
			print("mmm caca")
		
	

func take_damage(amount, hit_position):
	if shield > 0:
		self.shield = shield - amount
		var hitOnShield = hit_on_shield_resource.instance()
		$ShieldBarrier.add_child(hitOnShield)
		hitOnShield.global_position = hit_position


func _ready():
	yield(get_tree().create_timer(4), "timeout")
	print("que peo cachorros")
	battle_units.SpaceShip = self
	$EnergyBar.initialize(max_energy)
	$ShieldBar.initialize(max_shield)
	self.energy = max_energy
	self.shield = max_shield
	animation.play("Shield appear")
	
func _exit_tree():
	battle_units.SpaceShip = null
	
