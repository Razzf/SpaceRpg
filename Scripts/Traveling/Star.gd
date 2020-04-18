extends Node2D

const planet_scene = preload("res://Scenes/Traveling/Planet.tscn")
export(int) var planets_amount 
var prev_planet_position


func _ready():
	for i in range(planets_amount):
		var planet_to_add = planet_scene.instance()
		#print(planet_to_add.get_node("Area2D/CollisionShape2D").shape.radius)
		$Planets.add_child(planet_to_add)
		var randx = rand_range(-180, 360)
		var randy = rand_range(50, 130)
		var rand_planet_position = Vector2(randx, randy)
		if prev_planet_position != null:
			var diff_btwn_planets = rand_planet_position.distance_to(prev_planet_position)
			print(diff_btwn_planets)
			while diff_btwn_planets < 100:
				randx = rand_range(-180, 360)
				randy = rand_range(50, 130)
				rand_planet_position = Vector2(randx, randy)
				diff_btwn_planets = rand_planet_position.distance_to(prev_planet_position)
		planet_to_add.global_position = rand_planet_position
		prev_planet_position = rand_planet_position
	


func _on_SwipeDetector_swiped(direction):
	if direction == Vector2.RIGHT:
		$Planets.position.x = $Planets.position.x + 1.5
		pass
	elif direction == Vector2.LEFT:
		$Planets.position.x = $Planets.position.x - 1.5
		pass
