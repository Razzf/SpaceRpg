extends ShipModule
class_name Weapon

enum {TRIGGER_TYPE, LASER_TYPE}
export(int, "Trigger", "Laser") var weapon_type
export(int) var fire_rate
export(float, 0, 1) var accuracy
export(int) var damage
var trigger_counter = 0

export(PackedScene) var shot_scene

func _ready():
	name = "Weapon"

func shoot_to(_enemy):
	print("cacaaa")
	print(weapon_type," ", TRIGGER_TYPE)
	
	if weapon_type == TRIGGER_TYPE:
		print("simn es triger")
		for _i in range(fire_rate):
			var shot = shot_scene.instance()
			_enemy.add_child(shot)
			_enemy.take_damage(damage * accuracy)
			#shot.global_position = _enemy.global_position
			yield(shot, "tree_exited")
		#6.7


