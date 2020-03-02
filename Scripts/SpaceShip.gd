extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var animation : AnimationPlayer = $AnimationPlayer
onready var shield_hitted_sprites : Sprite = $Sprite
onready var shield_barrier = $ShieldBarrier


var max_shield = 2000
var shield setget setShield

var max_energy = 3500
var energy setget setEnergy

var equipped_weapon = null
var equipped_weapon2 = null
var equipped_weapon3 = null
var equipped_weapon4 = null

const Weapons = [
	preload("res://Scenes/Weapons/BlueSparks.tscn"),
	preload("res://Scenes/Weapons/Burning Laser.tscn"),
	preload("res://Scenes/Weapons/Explosive Bullets.tscn"),
	preload("res://Scenes/Weapons/Shield Recover.tscn"),
	preload("res://Scenes/Weapons/Electro Cannon.tscn"),
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
		add_child(equipped_weapon)
	else:
		equipped_weapon = Weapons[w_index]
		add_child(equipped_weapon)
		
func attack(_enemy) -> void:
	if _enemy != null:
		var explosions = equipped_weapon.shooting_scene.instance()
		var maxexplos = explosions.max_explosions
		
		for i in range(maxexplos):
			animation.play("attack")
			#$AnimationPlayer2.play("shaking")
			self.energy -= equipped_weapon.energy_cost/maxexplos
			#_enemy.take_damage(equipped_weapon.power)
			yield(animation,"animation_finished")
			
			
			if i == 0:
				equipped_weapon.trigger_counter = 0
				_enemy.add_child(explosions)
				
				
				
		battle_units.SpaceShip = self
		emit_signal("weapon_used")

func _ready():
	battle_units.SpaceShip = self
	$Bar.initialize(max_energy)
	$Bar2.initialize(max_shield)
	energy = max_energy
	shield = max_shield
	battle_units.Enemy.hp = battle_units.Enemy.max_hp
	emit_signal("Energy_Changed", energy)
	emit_signal("Shield_Changed",shield)
	

	
	shield_hitted_sprites.hide()
	#yield(get_tree().create_timer(4), "timeout")
	animation.play("Shield appear")
	update_equipped_weapon(2)
	
	
func _exit_tree():
	battle_units.SpaceShip = null
