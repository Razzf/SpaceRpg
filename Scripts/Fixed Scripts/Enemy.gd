extends Enemy

var acid = preload("res://Scenes/AcidSlime.tscn")
var prev_rand = 0
var rand_val

func take_damage(amount) -> void:

	create_random_shaking_animation(animation, "RndShaking")
	
	self.hp -= amount
	
	if is_dead():
		if animation.is_playing():
			animation.stop()
			animation.play("RndShaking")
			yield(animation,"animation_finished")
			queue_free()
	
		else:
			animation.play("RndShaking")
			yield(animation,"animation_finished")
			queue_free()
			
		emit_signal("dead")

	else:
		if animation.is_playing():
			animation.stop()
			animation.play("RndShaking")
		else:
			animation.play("RndShaking")


func attack() -> void:
	randomize()
	animation.play("prepare")
	yield(animation,"animation_finished")
	for _i in range(round(rand_range(3,6))):

		var temp_acid = acid.instance()
		self.add_child(temp_acid)
		yield(temp_acid, "almost_dead")

		battle_units.SpaceShip.take_damage(temp_acid.power, temp_acid.final_pos)

	animation.play_backwards("prepare")
	yield(animation, "animation_finished")
	emit_signal("enemy_attacked")

func create_random_shaking_animation(animPlayerObj, animName):
	var animashion = Animation.new()
	var track_index = animashion.add_track(Animation.TYPE_VALUE)
	var track_index2 = animashion.add_track(Animation.TYPE_VALUE)
	animashion.length = 0.25
	animashion.step = 0
	
	animashion.track_set_path(track_index, "Sprite:position")
	animashion.track_set_path(track_index2, "Sprite:frame")
	
	animashion.value_track_set_update_mode(track_index,animashion.UPDATE_CONTINUOUS )
	animashion.track_set_interpolation_type(track_index,animashion.INTERPOLATION_LINEAR)
	
	animashion.value_track_set_update_mode(track_index2,animashion.UPDATE_CONTINUOUS )
	animashion.track_set_interpolation_type(track_index2,animashion.INTERPOLATION_LINEAR)

	
	animashion.track_insert_key(track_index2, 0.0, 5)
	animashion.track_insert_key(track_index2, 0.01, 5)
	animashion.track_insert_key(track_index2, 0.02, 6)
	animashion.track_insert_key(track_index2, 0.03, 6)
	animashion.track_insert_key(track_index2, 0.05, 5)
	
	animashion.track_insert_key(track_index, 0.0, Vector2(0, 0))
	animashion.track_insert_key(track_index, 0.01, Vector2(0, 0))
	
	rand_val = rand_range(0, 20)
	
	while abs(rand_val - prev_rand) < 5:
		rand_val = rand_range(0, 20)
	prev_rand = rand_val
	
	animashion.track_insert_key(track_index, 0.02, Vector2(rand_val - 10, -12))
	animashion.track_insert_key(track_index, 0.05, Vector2(rand_val - 10, -12))
	animashion.track_insert_key(track_index, 0.2, Vector2(0, 0))

	animashion = animPlayerObj.add_animation(animName, animashion)
