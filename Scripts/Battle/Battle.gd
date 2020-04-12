  
extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

func _ready():
	yield(battle_units.Enemies, "all_appeared")
	battle_units.SpaceShip.initialize_combat()
	Start_Ship_Turn()
	

func Start_Ship_Turn() -> void:
	print("inicio tu turno")
	battle_units.SpaceShip.find_node("WeaponSelector", true, false).find_node("anim", true, false).play("Appear")
	var ship = battle_units.SpaceShip
	if ship != null:
		yield(ship, "end_turn")
		Start_Enemies_Turn()
	
	
func Start_Enemies_Turn() -> void:
	print("inicio el turno del enemigo")
	battle_units.SpaceShip.find_node("WeaponSelector", true, false).find_node("anim", true, false).play_backwards("Appear")
	var enemies = battle_units.Enemies
	if enemies != null:
		enemies.attack_secuence()
		yield(enemies, "end_turn")
		Start_Ship_Turn()
