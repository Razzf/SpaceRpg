extends Node2D
class_name Enemy

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

var max_hp = 1200
export(int) var hp = 1200 setget sethp
export(int) var damage = 4
var acid = preload("res://Scenes/AcidSlime.tscn")
var prev_rand = 0
var rand_val



onready var animation : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite


signal dead
signal enemy_atacked
signal hp_changed(value)

func is_dead() -> bool:
	return hp <= 0
	
func attack() -> void:
	battle_units.SpaceShip.shield_hitted_sprites.self_modulate = Color(0,0,0,0)
	battle_units.SpaceShip.shield_hitted_sprites.show()
	
	#var bit = round(rand_range(0, 1))
	var bit = 1

	
	if bit == 1:
		animation.play("prepare")
		yield(animation,"animation_finished")
		for i in range(round(rand_range(3,6))):
			
			if battle_units.acidslime != null:
				print("nu ma si habia acido :o")
				yield(battle_units.acidslime, "almost_dead")
				var temp_acid = acid.instance()
				self.add_child(temp_acid)
				yield(temp_acid, "almost_dead")
				print("termino la espera B)")
			else:
				print("no habia acido xddd")
				var temp_acid = acid.instance()
				self.add_child(temp_acid)
				yield(temp_acid, "almost_dead")
				
			
			var shield_hitted = preload("res://Scenes/ShieldHitted.tscn").instance()
			var particles = preload("res://Scenes/Slimeparticles.tscn").instance()
			var actual_acid = battle_units.acidslime
			
			if actual_acid != null:
				print(str(battle_units.acidslime.final_pos))
			else:
				print("actual acid doesnt exist")
			battle_units.SpaceShip.shield_barrier.add_child(shield_hitted)
			battle_units.SpaceShip.shield_barrier.add_child(particles)
			battle_units.SpaceShip.shield -= battle_units.acidslime.power
			shield_hitted.global_position = battle_units.acidslime.final_pos
			particles.global_position = battle_units.acidslime.final_pos
			
			yield(actual_acid, "dead")
		animation.play_backwards("prepare")
		yield(animation, "animation_finished")
			
	else:

		animation.play("Attack")
		yield(animation,"animation_finished")

	emit_signal("enemy_atacked")

func deal_damage() -> void:
	battle_units.SpaceShip.shield -= damage
	battle_units.SpaceShip.animation.play("Shield_Hitted")
	
func take_damage(amount) -> void:
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
		
	
	animashion.track_insert_key(track_index, 0.02, Vector2(rand_val - 10, -12))
	animashion.track_insert_key(track_index, 0.05, Vector2(rand_val - 10, -12))
	animashion.track_insert_key(track_index, 0.2, Vector2(0, 0))
	
	animation.add_animation("caca", animashion)
	
	prev_rand = rand_val
	self.hp -= amount
	if is_dead():
		if animation.is_playing():
			animation.stop()
			animation.play("caca")
			queue_free()
	
		else:
			animation.play("caca")
			yield(animation, "animation_finished")
			queue_free()
		emit_signal("dead")

	else:
		if animation.is_playing():
			animation.stop()
			animation.play("caca")
		else:
			animation.play("caca")


	
func sethp(value):
	hp = value
	emit_signal("hp_changed", value)


func _ready():
	battle_units.Enemy = self
	$Sprite/Enemyinf.initialize(max_hp)


func _exit_tree():
	battle_units.Enemy = null
	
