extends Node2D

const star_scene = preload("res://Scenes/Traveling/Star.tscn")

func _ready():
	pass
	
func move_stars(segs:int):
	$Stars.process_material.emission_box_extents = Vector3(9,16,1)
	$Stars.process_material.radial_accel = 100
	yield(get_tree().create_timer(segs), "timeout")
	$Stars.process_material.emission_box_extents = Vector3(90,160,1)
	$Stars.process_material.radial_accel = 0
	get_child(2).queue_free()
	var star_to_add = star_scene.instance()
	add_child(star_to_add)
	move_child(star_to_add, 2)
	
func change_star():
	get_child(2).queue_free()
	var star_to_add = star_scene.instance()
	add_child(star_to_add)
	move_child(star_to_add, 2)
	

func _on_Button_pressed():
	$AnimationPlayer.play("fade")

func on_full_fade():
	#remove_child(get_child(2))
	pass
	
	
	
	
	#print($Position2D/.get_child(0).get_node("Area2DSwipeDetector/CollisionShape2D").shape.extents)
