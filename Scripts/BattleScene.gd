extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

func _ready():
	battle_units.Enemy.animation.play("Idle")
	var battleUI = battle_units.BattleUI
	Start_Ship_Turn()

func Start_Ship_Turn() -> void:
	print("shipstarting turn")
	$BattleUI.add_child(preload("res://Scenes/ActionButtons.tscn").instance())
	var ship = battle_units.SpaceShip
	if ship != null:
		print("waiting to start turn")
		yield(ship, "weapon_used")
		print("enemy turn aboput to start")
		Start_Enemy_Turn()
	
	
func Start_Enemy_Turn() -> void:
	var enemy = battle_units.Enemy
	if enemy != null:
		if enemy.animation.is_playing():
			enemy.animation.get_animation("Idle").set_loop(false)
			yield(enemy.animation, "animation_finished")
		enemy.animation.get_animation("Idle").set_loop(true)
		enemy.attack()
		yield(enemy, "enemy_atacked")
		enemy.animation.play("Idle")
		var battleUI = battle_units.BattleUI
		Start_Ship_Turn()

func _on_BattleUI_turn_passed() -> void:
	Start_Enemy_Turn()
