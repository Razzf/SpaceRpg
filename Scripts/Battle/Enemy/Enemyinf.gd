extends Node2D

signal maximum_changed(maximum)
signal zero_hp

var maximum
var current_health = 0

func initialize(max_value):
	maximum = max_value
	emit_signal("maximum_changed", maximum)
	print("se realizo la inicializacion con:", max_value)

func animate_value(start, end):
	$Tween.interpolate_property($TextureProgress, "value", start, end, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_method(self, "update_count_text", start, end, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	

func update_count_text(value):
	$TextureProgress/Label.text = str(round(value)) + "/" + str(maximum) + "Hp"
	if value == 0:
		emit_signal("zero_hp")
	elif value < maximum/4:
		$TextureProgress.tint_progress = Color.red
	elif value < maximum/2:
		$TextureProgress.tint_progress = Color.yellow
	else:
		$TextureProgress.tint_progress = Color.green


func _on_Enemy_hp_changed(value):
	animate_value(current_health, value)
	update_count_text(value)
	current_health = value
