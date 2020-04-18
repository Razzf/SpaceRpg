extends Node2D

const planet_scene = preload("res://Scenes/Traveling/Planet.tscn")
export(int) var planets_amount 
var prev_planet_position


func _ready():
	for i in range(planets_amount):
		var planet_to_add = planet_scene.instance()
		$Planets.add_child(planet_to_add)
		var sep_pos = create_separate_pos($Planets.get_children())
		print("esta es la pos:", sep_pos)
		planet_to_add.global_position = sep_pos


	var kk = create_separate_pos($Planets.get_children())

	print("acabo")
	for planet in $Planets.get_children():
		print(planet.get_node("Area2D/CollisionShape2D").shape.radius)

func create_separate_pos(prev_planets:Array) -> Vector2:
	var new_vec = get_rand_vector(-180, 360, 80, 200)
	var fit = false
	
	if prev_planets.size() > 0:
		while not fit:
			new_vec = get_rand_vector(-180, 360, 80, 200)
			for i in range(prev_planets.size()):
				var prev_pos = prev_planets[i].global_position
				var diff = new_vec.distance_to(prev_pos)
				if diff < 80:
					break
				if prev_planets[i] == prev_planets.back():
					fit = true
		return new_vec
	else:
		return new_vec
				
	
	
	
#	if prev_planets.size() > 1:
#
#		for planet in prev_planets:
#
#			var prev_pos = planet.global_position
#			var diff = new_vec.distance_to(prev_pos)
#
#			while diff < 80:
#				new_vec = get_rand_vector(180, 360, 80, 200)
#				diff = new_vec.distance_to(prev_pos)
#
#			pass
#
#	return new_vec
#	pass

func get_rand_vector(rangx1, rangx2, rangy1, rangy2) -> Vector2:
	var randx = rand_range(rangx1, rangx2)
	var randy = rand_range(rangy1, rangy2)
	return Vector2(randx, randy)

func add_planet():
	var planet_to_add = planet_scene.instance()
	$Planets.add_child(planet_to_add)
	#print(planet_to_add.get_node("Area2D/CollisionShape2D").shape.radius)


func _on_SwipeDetector_swiped(direction):
	if direction == Vector2.RIGHT:
		$Planets.position.x = $Planets.position.x + 3
		pass
	elif direction == Vector2.LEFT:
		$Planets.position.x = $Planets.position.x - 3
		pass
