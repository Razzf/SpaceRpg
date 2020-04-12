extends Node2D
class_name Shot

export(float, 0, 50) var spawn_range_x
export(float, 0, 50) var spawn_range_y

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

func _ready():
	battle_units.Enemies.actual_enemy.take_damage(battle_units.SpaceShip.equipped_weapon.power)
	var x_range_rounded = int(round(spawn_range_x))
	var y_range_rounded = int(round(spawn_range_y))
	var enemy = battle_units.Enemies.actual_enemy
	if enemy != null:
		var enemy_position_x = enemy.global_position.x
		var enemy_position_y = enemy.global_position.y
		var randx = rand_range(enemy_position_x - x_range_rounded,
		enemy_position_x + x_range_rounded)
		var randy = rand_range(enemy_position_y - y_range_rounded,
		enemy_position_y + y_range_rounded)
		self.global_position = Vector2(randx, randy)
		

		
		
