extends Node2D
class_name Shooting

export(int) var max_explosions
export(float, 0, 50) var spawn_range_x
export(float, 0, 50) var spawn_range_y

var shooting = load("res://Scripts/WeaponAnimScripts/Shooting.gd")
const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

func _ready():
	var x_range_rounded = int(round(spawn_range_x))
	var y_range_rounded = int(round(spawn_range_y))
	var enemy = battle_units.Enemy
	if enemy != null:
		var enemy_position_x = enemy.global_position.x
		var enemy_position_y = enemy.global_position.y
		
		var randx = rand_range(enemy_position_x - x_range_rounded,
		enemy_position_x + x_range_rounded)
		var randy = rand_range(enemy_position_y - y_range_rounded,
		enemy_position_y + y_range_rounded)
			
			
		self.global_position = Vector2(randx, randy)
		
func _add_another_shot():
	var ship = battle_units.SpaceShip
	var enemy = battle_units.Enemy
	if ship != null and enemy != null:
		var weapon = battle_units.SpaceShip.equipped_weapon
		weapon.trigger_counter = weapon.trigger_counter + 1
		if weapon.trigger_counter < max_explosions:
			enemy.add_child(shooting.instance())
		
		
