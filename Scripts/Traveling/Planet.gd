extends Node2D

var atmosphere
var gravity
var temperature
var water
var planet_name

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
