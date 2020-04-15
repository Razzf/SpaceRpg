extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
const enemies_path = "res://Scenes/Battle/Enemy/enemies/"
var enemy_instances = []
var can_idle
export(int, 1, 5) var max_enemies
enum {LEFT, RIGHT}

signal inside_screen
signal outside_screen
signal end_turn
signal enemy_died
signal all_died
signal all_appeared

var actual_enemy = null


func _ready():
	#print("enemies")
	battle_units.Enemies = self
	var enemy_names = list_files_in_directory(enemies_path)
	for _i in range(max_enemies):
		randomize()
		enemy_names.shuffle()
		var enemy_path = enemies_path + enemy_names.front()
		enemy_instances.append(load(enemy_path).instance())
	yield(get_tree().create_timer(.5), "timeout")
	for _i in range(max_enemies):
		change_actual_enemy(RIGHT)
		yield(self, "inside_screen")
		actual_enemy.animation.play("roar")
		yield(actual_enemy.animation, "animation_finished")
		if _i == max_enemies -1:
			actual_enemy = $EnemyPos.get_child(0)
			actual_enemy.play_idle()
	can_idle = true
	emit_signal("all_appeared")
	
	
func  take_off_screen(direction:bool = RIGHT):
	if direction:
		if actual_enemy != null:
			actual_enemy.animation.play("swiping_right")
			yield(actual_enemy.animation, "animation_finished")
			$EnemyPos.remove_child(actual_enemy)
	else:
		if actual_enemy != null:
			#print("si hubo enemikk")
			actual_enemy.animation.play("swiping_left")
			yield(actual_enemy.animation, "animation_finished")
			$EnemyPos.remove_child(actual_enemy)
	emit_signal("outside_screen")
	
	
func put_on_screen(direction:bool = RIGHT):
	#print("puting on screen")
	if direction:
		var enemy_to_add = enemy_instances.front()
		$EnemyPos.add_child(enemy_to_add)
		actual_enemy = enemy_to_add
		actual_enemy.get_node("AnimationPlayer").play_backwards("swiping_left")
		yield(actual_enemy.animation, "animation_finished")
	else:
		var enemy_to_add = enemy_instances.front()
		$EnemyPos.add_child(enemy_to_add)
		actual_enemy = enemy_to_add
		actual_enemy.get_node("AnimationPlayer").play_backwards("swiping_right")
		yield(actual_enemy.animation, "animation_finished")
	if can_idle:
			actual_enemy.play_idle()
	emit_signal("inside_screen")
	
	
func rotate_enemies(direction:bool = RIGHT):
	if direction:
		enemy_instances.push_back(enemy_instances.front())
		enemy_instances.pop_front()
	else:
		enemy_instances.push_front(enemy_instances.back())
		enemy_instances.pop_back()
		
		
func change_actual_enemy(direction:bool = RIGHT) -> void:
	take_off_screen(direction)
	if actual_enemy != null:
		yield(self, "outside_screen")
	rotate_enemies(direction)
	put_on_screen(direction)


func attack_secuence():
	can_idle = false
	for i in range(enemy_instances.size()):
		if actual_enemy != null:
			print(actual_enemy.name, "atacando")
			actual_enemy.attack()
			yield(actual_enemy, "attacked")
			if i < enemy_instances.size() - 1:
				change_actual_enemy()
				yield(self, "inside_screen")
			else:
				emit_signal("end_turn")
				can_idle = true
				actual_enemy.play_idle()

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
	if enemy_instances.size() > 1:
		if direction == Vector2.RIGHT:
			change_actual_enemy(RIGHT)
		elif direction == Vector2.LEFT:
			change_actual_enemy(LEFT)

func _on_Enemy_dead(enemy):
	print("se va a eliminar un emeny")
	enemy_instances.erase(enemy)
	enemy.queue_free()
	actual_enemy = null
	if enemy_instances.size() > 0:
		put_on_screen(RIGHT)
		print("se agrego: ", actual_enemy.name)
	else:
		print("ganaste")
		emit_signal("all_died")
	

func _get_enemy_names() -> String:
	var names = ""
	for enemy in enemy_instances:
		names = names + " " + enemy.name
	return names

func _exit_tree():
	battle_units.Enemies = null
