extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
const enemies_dir = "res://Scenes/Battle/Enemy/enemies/"
var enemy_scenes = []
var enemy_instances = []

func _ready():
	Start_Ship_Turn()
	var max_enemies = 2
	var enemy_names = list_files_in_directory(enemies_dir)
	print("caca")
	for enemy_name in enemy_names:
		print("dentro de la caca")
		var dirtoappend = enemies_dir + enemy_name
		print(dirtoappend)
		enemy_scenes.append(dirtoappend)
	for _i in max_enemies:
		enemy_scenes.shuffle()
		enemy_instances.append(load(enemy_scenes.front()).instance())
	
	$EnemyPos.add_child(enemy_instances.front())

	
	


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
		enemy.attack()
		yield(enemy, "enemy_attacked")
		enemy.animation.get_animation("Idle").set_loop(true)
		enemy.animation.play("Idle")
		Start_Ship_Turn()

func _on_BattleUI_turn_passed() -> void:
	var ship = battle_units.SpaceShip
	ship.emit_signal("end_turn")

func change_target(right:bool = true) -> void:
	if !right:
		enemy_instances.push_front(enemy_instances.back())
		enemy_instances.pop_back()
		$EnemyPos.remove_child($EnemyPos.get_child(0))
		$EnemyPos.add_child(enemy_instances.front())
		$EnemyPos.get_child(0).get_node("AnimationPlayer").play_backwards("swiping_left")
	else:
		enemy_instances.push_back(enemy_instances.front())
		enemy_instances.pop_front()
		$EnemyPos.remove_child($EnemyPos.get_child(0))
		$EnemyPos.add_child(enemy_instances.front())
		$EnemyPos.get_child(0).get_node("AnimationPlayer").play_backwards("swiping_right")
	

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
