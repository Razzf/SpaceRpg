extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
const enemies_path = "res://Scenes/Battle/Enemy/enemies/"
var enemy_instances = []
var can_idle

signal change_finished
signal end_turn
signal enemy_died
signal all_died


func _ready():
	var max_enemies = 3
	var enemy_names = list_files_in_directory(enemies_path)
	
	for _i in range(max_enemies):
		randomize()
		enemy_names.shuffle()
		var enemy_path = enemies_path + enemy_names.front()
		enemy_instances.append(load(enemy_path).instance())

	yield(get_tree().create_timer(2), "timeout")
	
	for _i in range(max_enemies):
		change_target(true)
		yield(self, "change_finished")
		battle_units.Enemy.animation.play("roar")
		yield(battle_units.Enemy.animation, "animation_finished")
		if _i == max_enemies -1:
			battle_units.Enemy.animation.play("Idle")
	can_idle = true
	

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


func _on_SwipeDetector_swiped(direction):
	if direction == Vector2.RIGHT:
		change_target()
	elif direction == Vector2.LEFT:
		change_target(false)
