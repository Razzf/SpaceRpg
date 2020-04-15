extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
const enemies_path = "res://Scenes/Battle/Enemy/enemies/"
var enemy_instances = []
var can_idle
var attacks_counter = 0
export(int, 1, 5) var max_enemies

signal change_finished
signal end_turn
signal enemy_died
signal all_died
signal all_appeared

var actual_enemy = null


func _ready():
	battle_units.Enemies = self
	
	var enemy_names = list_files_in_directory(enemies_path)
	
	for _i in range(max_enemies):
		randomize()
		enemy_names.shuffle()
		var enemy_path = enemies_path + enemy_names.front()
		enemy_instances.append(load(enemy_path).instance())

	yield(get_tree().create_timer(.5), "timeout")
	
	for _i in range(max_enemies):
		change_actual_enemy()
		yield(self, "change_finished")
		actual_enemy.animation.play("roar")
		yield(actual_enemy.animation, "animation_finished")
		if _i == max_enemies -1:
			actual_enemy = $EnemyPos.get_child(0)
			actual_enemy.animation.play("Idle")
	can_idle = true
	
	emit_signal("all_appeared")

func change_actual_enemy(right:bool = true) -> void:
	if !right:
		if actual_enemy != null:
			actual_enemy.animation.play("swiping_left")
			yield(actual_enemy.animation, "animation_finished")
			$EnemyPos.remove_child(actual_enemy)
		enemy_instances.push_front(enemy_instances.back())
		enemy_instances.pop_back()
		var enemy_to_add = enemy_instances.front()
		$EnemyPos.add_child(enemy_to_add)
		actual_enemy = enemy_to_add
		actual_enemy.get_node("AnimationPlayer").play_backwards("swiping_right")
		yield(actual_enemy.animation, "animation_finished")
		emit_signal("change_finished")
		if can_idle:
			actual_enemy.animation.play("Idle")
	else:

		if actual_enemy != null:
			actual_enemy.animation.play("swiping_right")
			yield(actual_enemy.animation, "animation_finished")
			$EnemyPos.remove_child(actual_enemy)
		enemy_instances.push_back(enemy_instances.front())
		enemy_instances.pop_front()
		var enemy_to_add = enemy_instances.front()
		$EnemyPos.add_child(enemy_to_add)
		actual_enemy = enemy_to_add
		actual_enemy.get_node("AnimationPlayer").play_backwards("swiping_left")
		yield(actual_enemy.animation, "animation_finished")
		emit_signal("change_finished")
		if can_idle:
			actual_enemy.animation.play("Idle")
			
func attack_secuence():
	can_idle = false
	for i in range(max_enemies):
		if actual_enemy != null:
			print(actual_enemy.name, "atacando")
			actual_enemy.attack()
			yield(actual_enemy, "attacked")
			if i < max_enemies - 1:
				change_actual_enemy()
				yield(self, "change_finished")
			else:
				emit_signal("end_turn")

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
	if max_enemies > 1:
		if direction == Vector2.RIGHT:
			change_actual_enemy()
		elif direction == Vector2.LEFT:
			change_actual_enemy(false)

func _on_Enemy_dead(enemy):
	enemy_instances.erase(enemy)
	enemy.queue_free()
	actual_enemy = null
	change_actual_enemy()
	print(actual_enemy.name)


func _get_enemy_names() -> String:
	var names = ""
	for enemy in enemy_instances:
		names = names + " " + enemy.name
	return names

func _exit_tree():
	battle_units.Enemies = null
