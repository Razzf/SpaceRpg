extends Enemy

var acid = preload("res://Scenes/Battle/Enemy/attacks/AcidSlime.tscn")

var attacks = { "0":funcref(self, "tackle"), "1":funcref(self, "trow_slimes") }
var atcks_idx = ["0", "1"]

func trow_slimes(_n) -> void:
	randomize()
	animation.play("prepare")
	yield(animation,"animation_finished")
	for _i in range(_n):
		var temp_acid = acid.instance()
		self.add_child(temp_acid)
		yield(temp_acid, "almost_dead")
		battle_units.SpaceShip.take_damage(temp_acid.power, temp_acid.final_pos)
	animation.play_backwards("prepare")
	yield(animation, "animation_finished")
	emit_signal("enemy_attacked")

func attack():
	randomize()
	
	var index = round(rand_range(0,1))
	
	attacks[atcks_idx[index]].call_func(round(rand_range(0,6)))
	
