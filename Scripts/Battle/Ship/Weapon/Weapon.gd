extends ShipModule
class_name Weapon

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

enum {TRIGGER_TYPE, LASER_TYPE, ENERGY_TYPE}
export(int, "Trigger", "Laser", "Energy") var weapon_type
export(int) var fire_rate
export(float, 0, 1) var precision
export(int) var damage
export(bool) var is_empty = false

var trigger_counter = 0


signal on_used

export(Array, PackedScene) var shot_scenes

#func _ready():
#	name = "Weapon"
#
	

func shoot_to(_enemy):
	if weapon_type == TRIGGER_TYPE:
		for _i in range(fire_rate):
			var shot = shot_scenes[0].instance()
			self.get_node("AnimationPlayer").play("recoil")
			var fire = shot_scenes[1].instance()
			fire.z_index = -1
			self.get_node("Sprite/NozzlePosition").add_child(fire)
			yield(fire, "tree_exiting")
			_enemy.add_child(shot)
			battle_units.SpaceShip.energy -= energy_cost
			trigger_counter = trigger_counter + 1
			
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
			print(_i)
			if _enemy.hp <= 0:
				yield(fire, "tree_exited")
				emit_signal("on_used")
				break
			if _i < fire_rate -1:
				yield(fire, "tree_exited")
			else:
				yield(fire, "tree_exited")
				emit_signal("on_used")
				
				
	elif weapon_type == LASER_TYPE:
		pass
	elif weapon_type == ENERGY_TYPE:
		for _i in range(fire_rate):
			var shot = shot_scenes[0].instance()
			self.get_node("AnimationPlayer").play("recoil")
			self.get_node("Sprite/NozzlePosition").add_child(shot)
			yield(shot, "almost_dead")
			battle_units.SpaceShip.energy -= energy_cost
			trigger_counter = trigger_counter + 1
			
			_enemy.take_damage(damage)
			if _enemy.hp <= 0:
				yield(shot, "tree_exited")
				emit_signal("on_used")
				break
			if _i < fire_rate -1:
				pass
			else:
				yield(shot, "tree_exited")
				emit_signal("on_used")
				

func disappear():
	get_parent().remove_child(self)
	
func _enter_tree():
	if not self.is_empty:
		$AnimationPlayer.play("rotappear")
		
	

	

	
	

