extends "res://Scripts/Bar.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_SpaceShip_Shield_Changed(value):
	animate_value(current_health, value)
	update_count_text(value)
	current_health = value
