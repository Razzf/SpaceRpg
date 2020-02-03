extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

export(int) var hp = 25 setget sethp
export(int) var damage = 4

onready var hp_label = $Label
onready var animation = $AnimatedSprite
onready var sprite = $Sprite

signal dead
signal end_turn


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func sethp(value):
	pass
