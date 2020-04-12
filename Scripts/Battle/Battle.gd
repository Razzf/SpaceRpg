  
extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

func _ready():
	Start_Ship_Turn()
	

func Start_Ship_Turn() -> void:
	$MainControl.get_node("WeaponController").initialize()
	var ship = battle_units.SpaceShip
	if ship != null:
		yield(ship, "end_turn")
		Start_Enemies_Turn()
	
	
func Start_Enemies_Turn() -> void:
	var enemies = battle_units.Enemies
	if enemies != null:
		print("atacando")
		enemies.attack_secuence()
		yield(enemies, "end_turn")
		Start_Ship_Turn()



func _on_BattleUI_turn_passed() -> void:
	var ship = battle_units.SpaceShip
	ship.emit_signal("end_turn")

