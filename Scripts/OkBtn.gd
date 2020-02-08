extends "res://Scripts/ActionButton.gd"

signal weapon_used

func _on_pressed():
	var enemy = battle_units.Enemy
	var ship = battle_units.SpaceShip
	if enemy != null and ship != null:
		var weapon = ship.equipped_weapon
		enemy.take_damage(weapon.power)
		ship.energy -= weapon.energy_cost
		emit_signal("weapon_used")
