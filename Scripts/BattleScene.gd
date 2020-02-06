extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	battle_units.Enemy.animation.play("Idle")
	battle_units.ShipStats.planets = 12
	Start_Ship_Turn()

func Start_Ship_Turn():
	var ship = battle_units.ShipStats
	ship.ap = ship.max_ap
	yield(ship, "end_turn")
	Start_Enemy_Turn()
	
func Start_Enemy_Turn():
	var enemy = battle_units.Enemy
	yield(enemy.animation, "animation_finished")
	if enemy != null:
		enemy.attack()
		yield(enemy, "end_turn")
		enemy.animation.play("Idle")
	Start_Ship_Turn()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
