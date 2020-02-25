extends "res://Scripts/Bar.gd"


func _on_SpaceShip_Shield_Changed(value):
	animate_value(current_health, value)
	update_count_text(value)
	current_health = value
