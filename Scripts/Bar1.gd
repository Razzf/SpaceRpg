extends "res://Scripts/Fixed Scripts/Bar.gd"



func _ready():
	pass # Replace with function body.



func _on_SpaceShip_Energy_Changed(value):
	animate_value(current_health, value)
	update_count_text(value)
	current_health = value
