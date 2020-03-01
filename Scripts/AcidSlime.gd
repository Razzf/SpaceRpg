extends Node2D


export(int) var power


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var animashion = Animation.new()
	var pos_track_idx = animashion.add_track(Animation.TYPE_VALUE)
	var scl_track_idx = animashion.add_track(Animation.TYPE_VALUE)
	animashion.length = 0.20
	animashion.step = 0
	
	animashion.track_set_path(pos_track_idx, "Sprite:position")
	animashion.track_set_path(scl_track_idx, "Sprite:scale")
	
	animashion.value_track_set_update_mode(pos_track_idx,animashion.UPDATE_CONTINUOUS )
	animashion.track_set_interpolation_type(pos_track_idx,animashion.INTERPOLATION_LINEAR)
	
	animashion.value_track_set_update_mode(scl_track_idx,animashion.UPDATE_CONTINUOUS )
	animashion.track_set_interpolation_type(scl_track_idx,animashion.INTERPOLATION_LINEAR)
	
	animashion.track_insert_key(scl_track_idx, 0.0, Vector2(1, 1))
	animashion.track_insert_key(scl_track_idx, 0.05, Vector2(1.3, 1.3))
	animashion.track_insert_key(scl_track_idx, 0.1, Vector2(1.6, 1.6))
	animashion.track_insert_key(scl_track_idx, 0.15, Vector2(2, 2))
	animashion.track_insert_key(scl_track_idx, 0.2, Vector2(2.4, 2.4))
	
	animashion.track_insert_key(pos_track_idx, 0.0, Vector2(0, 0))
	var rand_valx = rand_range(0, 30)
	print(rand_valx)
	var rand_valy = rand_range(0,60)
	var bit = round(rand_range(0, 1))
	var bit2 = round(rand_range(0, 1))

	var trace
	var trace2
	
	if bit2 == 0:
		trace2 = -1
	else:
		trace2 = 1
	
	
	
	if bit == 0:
		trace = -1
	else:
		trace = 1
		
	print(trace)
	
	animashion.track_insert_key(pos_track_idx, 0.20, Vector2(rand_valx * trace, 60 * trace2))
	
	$AnimationPlayer.add_animation("caca", animashion)
	$AnimationPlayer.play("caca")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
	
	
	
	
	
