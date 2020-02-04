extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var StatsContainer = $UI/StatsContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	battle_units.Enemy.animation.play("Idle")
	battle_units.ShipStats.planets = 12
	Start_Ship_Turn()
	StatsContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	


func Start_Ship_Turn():
	StatsContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var ship = battle_units.ShipStats
	ship.ap = ship.max_ap
	yield(ship, "end_turn")
	Start_Enemy_Turn()
	
func Start_Enemy_Turn():
	StatsContainer.mouse_filter = Control.MOUSE_FILTER_PASS
	var enemy = battle_units.Enemy
	if enemy != null:
		enemy.attack()
		yield(enemy, "end_turn")
	Start_Ship_Turn()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
