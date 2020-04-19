extends Node2D


func _ready():
	var size_cord = int(rand_range(0,10))
	self.get_node("Sprite").frame = int(size_cord)
