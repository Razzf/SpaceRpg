extends Node2D


func _ready():
	randomize()
	var r = rand_range(0, 1)
	var g = rand_range(0, 1)
	var b = rand_range(0, 1)
	var size_cord = int(rand_range(0,10))
	$Sprite.self_modulate = Color(r, g, b, 1)
	print(size_cord)
	$Sprite.frame = int(size_cord)
