extends Node2D

export(int) var max_explosions = 3
var explosion = load("res://Scenes/Explosion.tscn")

func _ready():
	self.global_position = Vector2(rand_range(60,120), rand_range(60, 140))
	

func _add_another_explosion():
	get_parent().trigger_counter = get_parent().trigger_counter + 1
	if get_parent().trigger_counter <= max_explosions:
		print("adding explosion")
		get_parent().add_child(explosion.instance())
		
		
