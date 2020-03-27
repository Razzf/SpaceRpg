extends Node2D

enum types {DEFENSIVE_TYPE, PASSIVE_TYPE, OFFENSIVE_TYPE}
export(int) var power = null
export(int, "Deffensive", "Passive", "Offensive") var type = null
