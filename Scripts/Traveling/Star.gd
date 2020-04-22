extends Node2D

const planet_scene = preload("res://Scenes/Traveling/Planet.tscn")
const enemies_scene = preload("res://Scenes/Battle/Enemy/Enemies.tscn")

export(int) var planets_amount 
export(float, 1, 80) var min_separation
var last_direction

func _ready():
	randomize()
	var rand = rand_range(0, 1)
	var bit = int(round(rand))
	if false:
		print("bit")
		add_child(enemies_scene.instance())
		get_parent().get_parent().combat_state()
	
	print("voeagregarplanetssss")
	for i in range(planets_amount):
		var planet_to_add = planet_scene.instance()
		$Planets.add_child(planet_to_add, true)
		var sep_pos = create_separate_pos($Planets.get_children())
		
		var planet_anim = planet_to_add.get_node("AnimationPlayer")
		planet_to_add.create_random_appear(planet_anim, "caca", sep_pos)
		planet_anim.play("caca")

#		planet_to_add.global_position = sep_pos


func create_separate_pos(prev_planets:Array) -> Vector2:
	var new_vec = get_rand_vector(-180, 180,-45 , 45)
	var fit = false
	while not fit:
		#print("crando")
		new_vec = get_rand_vector(-180, 180,-45 , 45)
		for i in range(prev_planets.size()):
			var prev_pos = prev_planets[i].final_pos
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

func queue_planets():
	print("haciendo caca")
	for i in range($Planets.get_children().size()):
		var planets = $Planets.get_children()
		var planet = planets[i]
		planet.create_random_disappear("caca2")
		planet.get_node("AnimationPlayer").play("caca2")



func _on_Area2DSwipeDetector_swiped(direction):
	if direction == Vector2.RIGHT:
		last_direction = direction
		for planet in $Planets.get_children():
			planet.position.x = planet.position.x + 3
		pass
	elif direction == Vector2.LEFT:
		last_direction = direction
		for planet in $Planets.get_children():
			planet.position.x = planet.position.x - 3
		pass



