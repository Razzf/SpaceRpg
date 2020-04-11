extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

export(float, 0, 50) var dis_range

export(int) var power
var final_pos

signal dead
signal almost_dead
var can_free = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().get_parent().get_parent().get_scale().x == -1:

		self.set_scale(Vector2(-1, self.get_scale().y))
	if get_parent().get_parent().get_parent().get_scale().y == -1:

		self.set_scale(Vector2(self.get_scale().x, -1))
		
		pass
	$SparksParticles.hide()
	$Sprite.show()
	
	create_random_slime_anim()

	
	$AnimationPlayer.play("caca")
	yield($AnimationPlayer, "animation_finished")
	$Sprite.hide()
	
	
	can_free = true
	
	
	
	
	
	
	
func _exit_tree():
	emit_signal("dead")
	
func _process(_delta):
	if !$SparksParticles.emitting and can_free:
		queue_free()
		can_free = false

func on_almost_dead():
	$SparksParticles.show()
	$SparksParticles.emitting = true
	$SparksParticles.position = final_pos
	emit_signal("almost_dead")
	
func create_random_slime_anim():
	randomize()
	var animashion = Animation.new()
	var pos_track_idx = animashion.add_track(Animation.TYPE_VALUE)
	var scl_track_idx = animashion.add_track(Animation.TYPE_VALUE)
	var mtd_trac_index = animashion.add_track(Animation.TYPE_METHOD)
	
	animashion.length = 0.25
	animashion.step = 0
	
	animashion.track_set_path(mtd_trac_index, ".")
	animashion.track_set_path(pos_track_idx, "Sprite:position")
	animashion.track_set_path(scl_track_idx, "Sprite:scale")
	
	animashion.value_track_set_update_mode(pos_track_idx,animashion.UPDATE_CONTINUOUS )
	animashion.track_set_interpolation_type(pos_track_idx,animashion.INTERPOLATION_LINEAR)
	
	animashion.value_track_set_update_mode(scl_track_idx,animashion.UPDATE_CONTINUOUS )
	animashion.track_set_interpolation_type(scl_track_idx,animashion.INTERPOLATION_LINEAR)
	
	animashion.track_insert_key(scl_track_idx, 0.0, Vector2(1, 1))
	animashion.track_insert_key(scl_track_idx, 0.1, Vector2(.8, .8))
	animashion.track_insert_key(scl_track_idx, 0.15, Vector2(.5, .5))
	animashion.track_insert_key(scl_track_idx, 0.2, Vector2(.2, .2))
	animashion.track_insert_key(scl_track_idx, 0.25, Vector2(.1, .1))
	
	animashion.track_insert_key(mtd_trac_index, 0.2,
	 {"method": "on_almost_dead", "args": []})
	
	animashion.track_insert_key(pos_track_idx, 0.0, Vector2(0, 0))
	
	#var reference_point = Vector2(90 - self.global_position.x, 150 - self.global_position.y)
	var reference_point = Vector2(battle_units.Enemy.global_position.x - self.global_position.x, battle_units.Enemy.global_position.y - self.global_position.y)
	var rand_valx = rand_range(0, dis_range)
	var rand_valy = rand_range(0, dis_range)
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
		
	
	final_pos = Vector2(reference_point.x + rand_valx * trace,
	reference_point.y + rand_valy * trace2)
	
	animashion.track_insert_key(pos_track_idx, 0.25, Vector2(final_pos.x, final_pos.y))
	$AnimationPlayer.add_animation("caca", animashion)
	
	
