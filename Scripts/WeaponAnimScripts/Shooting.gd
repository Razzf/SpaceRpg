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
		print(x_range_rounded)
		print(spawn_range_y)
		self.global_position = Vector2(
			rand_range(enemy_position_x - x_range_rounded,
			enemy_position_y + x_range_rounded),
			rand_range(enemy_position_x - y_range_rounded,
			enemy_position_y + y_range_rounded)
		)
func _add_another_shot():
	if self.get_parent() != null:
		print(get_parent())
		get_parent().trigger_counter = get_parent().trigger_counter + 1
		print(battle_units.SpaceShip.equipped_weapon.trigger_counter)
		if get_parent().trigger_counter < max_explosions:
			get_parent().add_child(shooting.instance())
		
		
