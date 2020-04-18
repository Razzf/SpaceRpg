extends Node2D

var atmosphere
var gravity
var temperature
var water



func _ready():
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
	$AcceptDialog.dialog_text = get_desc()
	$AcceptDialog.popup_centered()

func upd_shape():
	self.get_node("Area2D/CollisionShape2D").shape.radius = self.get_node("Sprite").frame + 7

func get_desc() -> String:
	
	var text = "\nAtmosphere: {atm}%\nGravity: {gra}%\nTemperature: {tem}'C\nWater: {wat}%"
	var new_text = text.format({"atm":atmosphere, "gra":gravity, "tem":temperature, "wat":water})
	return new_text
