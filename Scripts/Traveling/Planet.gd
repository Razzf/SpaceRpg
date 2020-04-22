extends Node2D

var atmosphere
var gravity
var temperature
var water
var planet_name
var final_pos = Vector2.ZERO

var planet_names = ["Titan", "Osiris", "Dimidium", "Saffar",
					"Galileo", "Brahe", "Arion", "Harriot", "Dagon", "Hypatia" ]



func _ready():
	$AcceptDialog.get_ok().text = "Colonize"
	$AcceptDialog.get_ok().rect_size = Vector2(20,10)
	#$AcceptDialog.get_ok().set
	planet_name = rand_name()
	randomize()
	var r = rand_range(0, 1)
	var g = rand_range(0, 1)
	var b = rand_range(0, 1)
	var size_cord = int(rand_range(0,10))
	self.get_node("Sprite").self_modulate = Color(r, g, b, 1)
	self.get_node("Sprite").frame = int(size_cord)
	self.get_node("Area2D/CollisionShape2D").shape.radius = self.get_node("Sprite").frame + 7
	atmosphere = int(rand_range(0, 100))
	gravity = int(rand_range(0, 100))
	temperature = int(rand_range(-120, 120))
	water = int(rand_range(0, 100))

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch  and not event.pressed:
		$AcceptDialog.window_title = planet_name
		$AcceptDialog.dialog_text = get_desc()
		$AcceptDialog.popup_centered()

func upd_shape():
	self.get_node("Area2D/CollisionShape2D").shape.radius = self.get_node("Sprite").frame + 7

func get_desc() -> String:
	
	var text = "\nAtmosphere: {atm}%\nGravity: {gra}%\nTemperature: {tem}'C\nWater: {wat}%"
	var new_text = text.format({"atm":atmosphere, "gra":gravity, "tem":temperature, "wat":water})
	return new_text

func rand_name() -> String:
	var name = planet_names[rand_range(0, planet_names.size())]
	name = name + "-" + str(int(rand_range(0,10000)))
	return name
	pass

func create_random_appear(animPlayerObj, animName, final_poss):
	var animashion = Animation.new()
	var track_index = animashion.add_track(Animation.TYPE_VALUE)
	var track_index2 = animashion.add_track(Animation.TYPE_VALUE)
	var init_pos = Vector2.ZERO
	animashion.length = 0.40
	animashion.step = 0
	
	animashion.track_set_path(track_index, ".:position")
	animashion.track_set_path(track_index2, ".:scale")
	
	animashion.value_track_set_update_mode(track_index,animashion.UPDATE_CONTINUOUS )
	animashion.track_set_interpolation_type(track_index,animashion.INTERPOLATION_LINEAR)
	
	animashion.value_track_set_update_mode(track_index2,animashion.UPDATE_CONTINUOUS )
	animashion.track_set_interpolation_type(track_index2,animashion.INTERPOLATION_LINEAR)

	#scale track
	animashion.track_insert_key(track_index2, 0.0, Vector2(.01, .01))
	animashion.track_insert_key(track_index2, .40, Vector2(1, 1))
	
	#position track
	animashion.track_insert_key(track_index, 0.0, init_pos)
	final_pos = final_poss
	
	animashion.track_insert_key(track_index, .40, final_pos)
	
	animashion = animPlayerObj.add_animation(animName, animashion)

func create_random_disappear(animName):
	var animashion = Animation.new()
	var track_index = animashion.add_track(Animation.TYPE_VALUE)
	var track_index2 = animashion.add_track(Animation.TYPE_VALUE)
	var mtd_trac_index = animashion.add_track(Animation.TYPE_METHOD)
	var init_pos = Vector2(90, 150)
	animashion.length = 0.40
	animashion.step = 0
	
	animashion.track_set_path(mtd_trac_index, ".")
	animashion.track_set_path(track_index, ".:position")
	animashion.track_set_path(track_index2, ".:scale")
	
	animashion.value_track_set_update_mode(track_index,animashion.UPDATE_CONTINUOUS )
	animashion.track_set_interpolation_type(track_index,animashion.INTERPOLATION_LINEAR)
	
	animashion.value_track_set_update_mode(track_index2,animashion.UPDATE_CONTINUOUS )
	animashion.track_set_interpolation_type(track_index2,animashion.INTERPOLATION_LINEAR)

	#scale track
	animashion.track_insert_key(track_index2, 0.0, Vector2(1, 1))
	animashion.track_insert_key(track_index2, .40, Vector2(2, 2))
	
	animashion.track_insert_key(mtd_trac_index, 0.40,
	 {"method": "queue_free", "args": []})
	
	#position track
	animashion.track_insert_key(track_index, 0.0, position)
	var final_poss = position * 2
	
	
	
	animashion.track_insert_key(track_index, .40, final_poss)
	
	animashion = $AnimationPlayer.add_animation(animName, animashion)
	pass





















