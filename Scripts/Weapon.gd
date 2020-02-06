extends Node2D

enum types {DEFENSIVE_TYPE, PASSIVE_TYPE, OFFENSIVE_TYPE}
export(Texture) var icon_texture = null
export(int) var cost = null
export(int) var power = null
export(int, "Deffensive", "Passive", "Offensive") var type = null
onready var Name = get_tree().current_scene.name

onready var icon = $Icon
onready var animation = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready():
	icon.texture = icon_texture
	pass

	

