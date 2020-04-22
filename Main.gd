extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

enum {
	TRAVELING,
	COMBAT
}
var state = TRAVELING

func _ready():
	battle_units.main = self




func Start_Ship_Turn() -> void:
	print("inicio tu turnoOOOOOO")
	if battle_units.Enemies != null:
		battle_units.SpaceShip.initialize_turn()
		var ship = battle_units.SpaceShip
		if ship != null:
			yield(ship, "end_turn")
			print("acabo tu turnoOOOOOO")
			Start_Enemies_Turn()
	
	
func Start_Enemies_Turn() -> void:
	print("inicio el turno del enemigo000000000")
	var enemies = battle_units.Enemies
	if enemies != null:
		if enemies.actual_enemy.hp <= 0:
			yield(enemies, "inside_screen")
			enemies.attack_secuence()
		else:
			enemies.attack_secuence()
		yield(enemies, "end_turn")
		print("acabo el turno del enemigo000000000")
		Start_Ship_Turn()


func set_state(state):
	match state:
		COMBAT:
			combat_state()
		TRAVELING:
			traveling_state()
	pass

func combat_state():
	battle_units.Enemies.create()
	yield(battle_units.Enemies, "all_appeared")
	battle_units.SpaceShip.combat_mode()
	Start_Ship_Turn()

func traveling_state():
	battle_units.SpaceShip.traveling_mode()
	pass


