extends Node2D
class_name Enemy

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

export(int)var max_hp
export(int) var physical_damage
export(int) var special_damage
var hp setget sethp
var rand_val
var prev_rand = 0

onready var animation : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite

signal dead
signal enemy_attacked
signal hp_changed(value)

func is_dead() -> bool:
	return hp <= 0
	
func tackle(_n) -> void:
	print("POPOSOTAAAA")
	animation.play("Attack")
	yield(animation,"animation_finished")
	emit_signal("enemy_attacked")

func deal_p_damage() -> void:
	battle_units.SpaceShip.take_damage(physical_damage, Vector2(global_position.x, global_position.y + 20))

func deal_s_damage() -> void:
	battle_units.SpaceShip.take_damage(physical_damage, Vector2(global_position.x, global_position.y))

func take_damage(amount) -> void:

	create_random_shaking(animation, "RndShaking")
	
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
			
func sethp(value):
	hp = value
	if is_dead():
		emit_signal("dead")
	emit_signal("hp_changed", value)

func create_random_shaking(animPlayerObj, animName):
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

	
	animashion.track_insert_key(track_index2, 0.0, 1)
	animashion.track_insert_key(track_index2, 0.01, 1)
	animashion.track_insert_key(track_index2, 0.02, 1)
	animashion.track_insert_key(track_index2, 0.03, 0)
	animashion.track_insert_key(track_index2, 0.05, 0)
	
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


func _ready():
	battle_units.Enemy = self
	$Sprite/HpBar.initialize(max_hp)
	


	
func _exit_tree():
	battle_units.Enemy = null


