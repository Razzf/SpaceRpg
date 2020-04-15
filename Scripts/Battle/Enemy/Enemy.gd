extends Node2D
class_name Enemy

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

export(int)var max_hp
export(int) var physical_damage
export(int) var special_damage
var hp  setget sethp
var rand_val
var prev_rand = 0
var init_posx
export(float, 0.1, 100.00)  var swipe_sensitiviy
var canchange
var can_idle = true
var is_ready = false


onready var animation = $AnimationPlayer
onready var sprite : Sprite = $Sprite

signal dead
signal attacked
signal hp_changed(value)
	
func tackle(_n) -> void:
	self.animation.play("Attack")
	yield(self.animation,"animation_finished")
	emit_signal("attacked")

func deal_p_damage() -> void:
	battle_units.SpaceShip.take_damage(physical_damage, Vector2(global_position.x, global_position.y + 20))

func take_damage(amount) -> void:
	
	create_random_shaking(animation, "RndShaking")
	self.hp -= amount
	
	if is_dead():
		if animation.is_playing():
			animation.stop()
			animation.play("RndShaking")
			yield(animation,"animation_finished")
		else:
			animation.play("RndShaking")
			yield(animation,"animation_finished")
		
		yield($Sprite/Bar, "zero_hp")
		emit_signal("dead", self)
	else:
		if animation.is_playing():
			animation.stop()
			animation.play("RndShaking")
		else:
			animation.play("RndShaking")
			
	if can_idle:
		can_idle = false
		if animation.is_playing():
			yield(animation, "animation_finished")
			play_idle()

			
func sethp(value):
	hp = clamp(value, 0, max_hp)
	emit_signal("hp_changed", hp)




func _ready():
	is_ready = true
	print("ready")
	$Sprite/Bar.initialize(max_hp)
	self.hp = max_hp
	if !self.is_connected("dead", get_parent().get_parent(), "_on_Enemy_dead"):
		self.connect("dead", get_parent().get_parent(), "_on_Enemy_dead")

func _enter_tree():
	canchange = true

	
func _exit_tree():
	print("enter treee")
	pass

func play_idle():
	var anim = get_node("AnimationPlayer")
	if anim.has_animation("Idle"):
		anim.play("Idle")
	


func attack():
	tackle(1)
	
				
func ready_to_show():
	if animation.get_playing_speed() == -1:
		self.hide()
	else:
		self.show()

func is_dead() -> bool:
	return hp <= 0
	

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

