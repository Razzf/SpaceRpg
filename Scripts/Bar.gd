extends Node2D

signal maximum_changed(maximum)
export(String, "Sp", "Ep") var bar_type = null

var maximum = 2000
var current_health = 0

func initialize(max_value):
	maximum = max_value
	emit_signal("maximum_changed", maximum)



func animate_value(start, end):
	$Tween.interpolate_property($TextureProgress, "value", start, end, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.interpolate_method(self, "update_count_text", start, end, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	print("caca")


func update_count_text(value):
	$Panel/Label.text = str(round(value)) + str(bar_type)


