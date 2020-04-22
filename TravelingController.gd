extends Control

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")


func _ready():
	pass


func _on_SpaceshipBtn_pressed():
	pass # Replace with function body.


func _on_PlanetsBtn_pressed():
	pass # Replace with function body.


func _on_StarsBtn_pressed():
	battle_units.main.get_node("Space").move_stars(2)
