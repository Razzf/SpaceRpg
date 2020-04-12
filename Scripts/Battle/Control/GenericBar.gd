extends TextureProgress

signal zero_hp
var maximum
var current_health = 0
export(bool) var changeable_color
export(Color) var custom_color
export(float) var visibility
export(int, "Linear", "Sine", "Quint", "Quart", "Quad", "expo", "Elastic", "Cubic", "Circ", "Bounce", "Back") var Trans_type
#export(Color) var medium_bar 
#export(Color) var quarter_bar
export(String, "Hp", "Sp", "Ep") var value_type

func _ready():
	if value_type == "Sp" || value_type == "Ep":
		$Label.self_modulate.a = visibility
	if !changeable_color:
		custom_color.a = visibility
		self.tint_progress = custom_color


func initialize(max_value):
	maximum = max_value
	self.max_value = maximum

func animate_value(start, end):
	$Tween.interpolate_property(self, "value", start, end, 1, Trans_type, Tween.EASE_OUT)
	$Tween.interpolate_method(self, "update_count_text", start, end, 1, Trans_type, Tween.EASE_OUT)
	$Tween.start()
	

func update_count_text(value):
	$Label.text = str(round(value)) + value_type + "\n"
	if value == 0:
		emit_signal("zero_hp")
	
	if changeable_color:
		if value < maximum/4:
			self.tint_progress = Color( 1, 0, 0, visibility)
		elif value < maximum/2:
			self.tint_progress = Color( 1, 1, 0, visibility)
		else:
			self.tint_progress = Color( 0, 1, 0, visibility)


func _on_value_changed(value):
	animate_value(current_health, value)
	update_count_text(value)
	current_health = value
