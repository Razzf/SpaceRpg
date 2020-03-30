extends ShipModule
class_name Weapon

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

enum {TRIGGER_TYPE, LASER_TYPE}
export(int, "Trigger", "Laser") var weapon_type
export(int) var fire_rate
export(float, 0, 1) var precision
export(int) var damage
var trigger_counter = 0

signal on_used

export(PackedScene) var shot_scene

func _ready():
	name = "Weapon"

func shoot_to(_enemy):
	if weapon_type == TRIGGER_TYPE:
		for _i in range(fire_rate):
			var shot = shot_scene.instance()
			_enemy.add_child(shot)
			battle_units.SpaceShip.energy -= energy_cost
			trigger_counter = trigger_counter + 1
			if trigger_counter == fire_rate:
				emit_signal("on_used")
			var max_y = _enemy.get_node("Sprite").texture.get_height()/2
			var max_x = _enemy.get_node("Sprite").texture.get_width()/4
			var rand_x = rand_range(-max_x,max_x) * abs(precision - 1)
			var rand_y = rand_range(-max_y,max_y) * abs(precision - 1)
			var rand_vector2 = Vector2(rand_x, rand_y)
			shot.global_position += rand_vector2
			var hip = sqrt(pow(rand_x, 2) + pow(rand_y, 2))
			var max_hip = sqrt(pow(max_x, 2) + pow(max_y, 2))
			var accuracy = 1 - (hip / max_hip)
			_enemy.take_damage(damage * accuracy)
			yield(shot, "tree_exited")
	elif weapon_type == LASER_TYPE:
		pass

