  
extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

func _ready():
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

