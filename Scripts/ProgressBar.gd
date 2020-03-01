extends ProgressBar


var maximum = 100
var current_health = 0

func initialize(max_valuee):
	max_value = max_valuee



func animate_value(start, end):
	pass
	#$Tween.interpolate_property(self, "value", start, end, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	#$Tween.start()


func _on_SpaceShip_Energy_Changed(new_energy):
	animate_value(current_health, new_energy)
	current_health = new_energy
