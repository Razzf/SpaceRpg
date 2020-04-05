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

var first_pressed = false

onready var animation : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite

signal dead
signal enemy_attacked
signal hp_changed(value)
signal swiped(dir)

func is_dead() -> bool:
	return hp <= 0
	
func tackle(_n) -> void:
	self.animation.play("Attack")
	yield(self.animation,"animation_finished")
	emit_signal("enemy_attacked")

func deal_p_damage() -> void:
	battle_units.SpaceShip.take_damage(physical_damage, Vector2(global_position.x, global_position.y + 20))

func take_damage(amount) -> void:
	print("enemy tacking damage")

	create_random_shaking(animation, "RndShaking")
	if animation.has_animation("RndShaking"):
		print("smn si la tiene")
	
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
		emit_signal("dead")
		queue_free()
	else:
		if animation.is_playing():
			animation.stop()
			print("about to play rndm shaking")
			animation.play("RndShaking")
		else:
			animation.play("RndShaking")
			
func sethp(value):
	hp = clamp(value, 0, max_hp)
	emit_signal("hp_changed", hp)

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
	
	self.connect("swiped",get_parent().get_parent(),"change_target")
	$Sprite/Bar.initialize(max_hp)
	self.hp = max_hp
	
	
func _enter_tree():
	battle_units.Enemy = self
	if animation != null:
		if !animation.is_playing():
			self.animation.get_animation("Idle").set_loop(true)
			self.animation.play("Idle")
			print("playing idle")

	canchange = true
	
func _exit_tree():
	print("el nodo enemy salio")
	battle_units.Enemy = null

func attack():
	tackle(1)
	print("smn kk con pan")

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch:
		init_posx = event.position.x
		print("popo agarre el primero")
		first_pressed = true
	if event is InputEventScreenDrag and first_pressed:
		var dragposx = event.position.x
		if dragposx != null:
			var difference = dragposx - init_posx
			if difference >= (30) and canchange:
				canchange = false
				first_pressed = false
#				animation.play("swiping_right")
#				yield(animation,"animation_finished")
				emit_signal("swiped")
			if difference <= - (30) and canchange:
				canchange = false
				first_pressed = false
#				animation.play("swiping_left")
#				yield(animation,"animation_finished")
				emit_signal("swiped", false)
				
func ready_to_show():
	if animation.get_playing_speed() == -1:
		self.hide()
	else:
		self.show()
			

