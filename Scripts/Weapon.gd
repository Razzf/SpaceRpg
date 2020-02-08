extends Node2D

enum types {DEFENSIVE_TYPE, PASSIVE_TYPE, OFFENSIVE_TYPE}
export(Texture) var icon_texture = null
export(int) var energy_cost = null setget set_energy_cost
export(int) var power = null
export(int, "Deffensive", "Passive", "Offensive") var type = null
onready var _name = self.name
onready var animation = $AnimationPlayer


func set_energy_cost(value):
	energy_cost = value
	
func _ready():
	name = "Weapon"

	

