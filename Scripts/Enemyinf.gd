extends Node2D

signal maximum_changed(maximum)

var maximum
var current_health = 0

func initialize(max_value):
	maximum = max_value
	emit_signal("maximum_changed", maximum)
	print("cacaaa")

func animate_value(start, end):
	print("mmmm")

	$Tween.interpolate_property($Panel2/TextureProgress, "value", start, end, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.interpolate_method(self, "update_count_text", start, end, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	

func update_count_text(value):
	$Panel2/TextureProgress/Panel.text = str(round(value)) + "/" + str(maximum) + "Hp"
	
func _on_Enemy_hp_changed(value):
	if value <= maximum/2:
		$Panel2/TextureProgress.self_modulate = Color.yellow
	if value <= maximum/4:
		$Panel2/TextureProgress.self_modulate = Color.red
	animate_value(current_health, value)
	update_count_text(value)
	current_health = value
