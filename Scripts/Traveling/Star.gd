extends Node2D

const planet_scene = preload("res://Scenes/Traveling/Planet.tscn")
export(int) var planets_amount 


func _ready():
	for i in range(planets_amount):
		var planet_to_add = planet_scene.instance()
		$Planets.add_child(planet_to_add)
		var randx = rand_range(-180, 360)
		var randy = rand_range(50, 100)
		var rand_planet_position = Vector2(randx, randy)
		planet_to_add.global_position = rand_planet_position
	
