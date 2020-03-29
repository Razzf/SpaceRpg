extends Node2D
class_name ShipModule


enum {DEFFENSIVE_TYPE, PASSIVE_TYPE, OFFENSIVE_TYPE}
export(Texture) var icon_texture = null
export(int) var energy_cost = null setget set_energy_cost
export(int) var power = null
export(int, "Deffensive", "Passive", "Offensive") var module_type = null
onready var _name = self.name

var description : String

func set_energy_cost(value):
	energy_cost = value

func get_description() -> String:
	return description + "\n" + "Power: " + str(
		power)+ "\n" + "Energy Cost: " + str(
		energy_cost) + "\n\n\n\n Use this weapon?"
