extends Node2D

const star_scene = preload("res://Scenes/Traveling/Star.tscn")

func _ready():
	pass


func _on_Button_pressed():
	$AnimationPlayer.play("fade")

func on_full_fade():
	$Position2D.remove_child($Position2D/.get_child(0))
	$Position2D.add_child(star_scene.instance())
	print($Position2D/.get_child(0).get_node("Area2DSwipeDetector/CollisionShape2D").shape.extents)
