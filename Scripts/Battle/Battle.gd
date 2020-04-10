  
extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
const enemies_dir = "res://Scenes/Battle/Enemy/enemies/"
var enemy_scenes = []
var enemy_instances = []
var first_pressed
var init_posx
var canchange
var can_idle

signal change_finished

func _ready():
	var max_enemies = 3
	var enemy_names = list_files_in_directory(enemies_dir)
	for enemy_name in enemy_names:
		var dirtoappend = enemies_dir + enemy_name
		enemy_scenes.append(dirtoappend)
	for _i in range(max_enemies):
		enemy_instances.append(load(enemy_scenes[_i]).instance())
	var temp_init_enemy = load(enemy_scenes[0]).instance()
	temp_init_enemy.show()
	$EnemyPos.add_child(temp_init_enemy)
	
	for _i in range(max_enemies):
		battle_units.Enemy.animation.play("roar")
		yield(battle_units.Enemy.animation, "animation_finished")
		if _i < range(max_enemies).size() -1:
			change_target(true)
			yield(self,"change_finished")
		else:
			battle_units.Enemy.animation.play("Idle")
	can_idle = true
	Start_Ship_Turn()
		
		



	


func Start_Ship_Turn() -> void:
	$MainControl.add_child(preload("res://Scenes/Battle/Control/WeaponSelector.tscn").instance())
	var ship = battle_units.SpaceShip
	if ship != null:
		yield(ship, "end_turn")
		Start_Enemy_Turn()
	
	
func Start_Enemy_Turn() -> void:
	var enemy = battle_units.Enemy
	if enemy != null:
		if enemy.animation.is_playing():
			enemy.animation.get_animation("Idle").set_loop(false)
			yield(enemy.animation, "animation_finished")
		for _i in range(3):
			var _enemy = battle_units.Enemy
			if _enemy.animation.is_playing():
				yield(_enemy.animation, "animation_finished")
				_enemy.attack()
				yield(_enemy, "enemy_attacked")
				if _i < 2:
					change_target()
					yield(self,"change_finished")
			else:
				_enemy.attack()
				yield(_enemy, "enemy_attacked")
				if _i < 2:
					change_target()
					yield(self,"change_finished")
		enemy.animation.get_animation("Idle").set_loop(true)
		enemy.animation.play("Idle")
		Start_Ship_Turn()



func _on_BattleUI_turn_passed() -> void:
	var ship = battle_units.SpaceShip
	ship.emit_signal("end_turn")



func change_target(right:bool = true) -> void:
	if !right:
		if battle_units.Enemy != null:
			battle_units.Enemy.animation.play("swiping_left")
			yield(battle_units.Enemy.animation, "animation_finished")
			$EnemyPos.remove_child(battle_units.Enemy)
		enemy_instances.push_front(enemy_instances.back())
		enemy_instances.pop_back()
		$EnemyPos.add_child(enemy_instances.front())
		$EnemyPos.get_child(0).get_node("AnimationPlayer").play_backwards("swiping_right")
		yield(battle_units.Enemy.animation, "animation_finished")
		emit_signal("change_finished")
		if can_idle:
			battle_units.Enemy.animation.play("Idle")

		#
	else:
		if battle_units.Enemy != null:
			battle_units.Enemy.animation.play("swiping_right")
			yield(battle_units.Enemy.animation, "animation_finished")
			$EnemyPos.remove_child(battle_units.Enemy)
		enemy_instances.push_back(enemy_instances.front())
		enemy_instances.pop_front()
		$EnemyPos.add_child(enemy_instances.front())
		$EnemyPos.get_child(0).get_node("AnimationPlayer").play_backwards("swiping_left")
		yield(battle_units.Enemy.animation, "animation_finished")
		emit_signal("change_finished")
		if can_idle:
			battle_units.Enemy.animation.play("Idle")
	

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			init_posx = event.position.x
			first_pressed = true
	if event is InputEventScreenDrag and first_pressed:
		var dragposx = event.position.x
		if dragposx != null:
			var difference = dragposx - init_posx
			if difference >= (30) and battle_units.Enemy.canchange:
				canchange = false
				first_pressed = false
				change_target()
			if difference <= - (30) and battle_units.Enemy.canchange:
				canchange = false
				first_pressed = false
				change_target(false)
