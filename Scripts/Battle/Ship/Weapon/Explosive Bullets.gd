extends Weapon

func _ready():
	description = "Rifle chargued with explosive bullets \n"

export(float, 0, 50) var spawn_range_x
export(float, 0, 50) var spawn_range_y

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

