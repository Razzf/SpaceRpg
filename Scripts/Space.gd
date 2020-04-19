extends Node2D

const star_scene = preload("res://Scenes/Traveling/Star.tscn")

func _ready():
	pass


func _on_Button_pressed():
	$AnimationPlayer.play("fade")

func on_full_fade():
	#remove_child(get_child(2))
	get_child(2).queue_free()
	var star_to_add = star_scene.instance()
	add_child(star_to_add)
	move_child(star_to_add, 2)
	#print($Position2D/.get_child(0).get_node("Area2DSwipeDetector/CollisionShape2D").shape.extents)
