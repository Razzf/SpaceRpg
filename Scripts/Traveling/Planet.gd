extends Node2D


func _ready():
	randomize()
	var r = rand_range(0, 1)
	var g = rand_range(0, 1)
	var b = rand_range(0, 1)
	var size_cord = int(rand_range(0,10))
	self.get_node("Sprite").self_modulate = Color(r, g, b, 1)
	#print(size_cord)
	self.get_node("Sprite").frame = int(size_cord)
	self.get_node("Area2D/CollisionShape2D").shape.radius = size_cord + 7


func _on_Area2D_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
