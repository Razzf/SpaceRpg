extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

func _ready():
	battle_units.Enemy.animation.play("Idle")
	Start_Ship_Turn()


func Start_Ship_Turn() -> void:
	print("oeeeeeeeeeeeeeee")
	$BattleUI.add_child(preload("res://Scenes/ActionButtons.tscn").instance())
	var ship = battle_units.SpaceShip
	if ship != null:
		yield(ship, "weapon_used")
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
		print("oeeeeeeeeeee")
		Start_Ship_Turn()

func _on_BattleUI_turn_passed() -> void:
	var ship = battle_units.SpaceShip
	ship.emit_signal("weapon_used")
