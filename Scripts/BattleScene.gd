extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

func _ready():
	battle_units.Enemy.animation.play("Idle")
	Start_Ship_Turn()

func Start_Ship_Turn():
	var battleUI = battle_units.BattleUI
	battleUI.actionBtns.show()
	var ship = battle_units.SpaceShip
	if ship != null:
		yield(ship, "Energy_Changed")
		Start_Enemy_Turn()
	yield(battleUI, "turn_passed")
	Start_Enemy_Turn()
	
func Start_Enemy_Turn():
	var enemy = battle_units.Enemy
	yield(enemy.animation, "animation_finished")
	if enemy != null:
		enemy.attack()
		yield(enemy, "enemy_atacked")
		enemy.animation.play("Idle")
	Start_Ship_Turn()
