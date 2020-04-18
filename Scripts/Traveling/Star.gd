extends Node2D

const planet_scene = preload("res://Scenes/Traveling/Planet.tscn")
export(int) var planets_amount 
export(float, 1, 80) var min_separation

func _ready():
	for i in range(planets_amount):
		var planet_to_add = planet_scene.instance()
		$Planets.add_child(planet_to_add, true)
		var sep_pos = create_separate_pos($Planets.get_children())
		planet_to_add.global_position = sep_pos
		


func create_separate_pos(prev_planets:Array) -> Vector2:
	var new_vec = get_rand_vector(-180, 360, 80, 200)
	var fit = false
	while not fit:
		new_vec = get_rand_vector(-180, 360, 80, 200)
		for i in range(prev_planets.size()):
			var prev_pos = prev_planets[i].global_position
			var diff = new_vec.distance_to(prev_pos)
			if diff < min_separation:
				break
			if prev_planets[i] == prev_planets.back():
				fit = true
	return new_vec


func get_rand_vector(rangx1, rangx2, rangy1, rangy2) -> Vector2:
	var randx = rand_range(rangx1, rangx2)
	var randy = rand_range(rangy1, rangy2)
	return Vector2(randx, randy)

func add_planet():
	var planet_to_add = planet_scene.instance()
	$Planets.add_child(planet_to_add)

func _on_SwipeDetector_swiped(direction):
	if direction == Vector2.RIGHT:
		$Planets.position.x = $Planets.position.x + 3
		pass
	elif direction == Vector2.LEFT:
		$Planets.position.x = $Planets.position.x - 3
		pass
