extends ReferenceRect


export(float, 0.01, 1) var touch_sensitivity
export(bool) var reiterative
var init_vec = Vector2.ZERO
var swipe_direction = Vector2.ZERO
var swipe_length = Vector2.ZERO
var fixed_sens
var can_swipe = false
signal swiped(direction)

func _ready():
	fixed_sens = 101 - ((touch_sensitivity) * 100)

func _on_SwipeDetector_gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			init_vec = event.position
			can_swipe = true
		else:
			can_swipe = false
		
	if event is InputEventScreenDrag and can_swipe:
		
		swipe_direction = init_vec.direction_to(event.position).round()
		swipe_length =  init_vec.distance_to(event.position)
		print(swipe_length)
		
		if swipe_length >= fixed_sens:
			if reiterative:
				init_vec = event.position
			else:
				can_swipe = false
			emit_signal("swiped", swipe_direction)
			print("swipeo")
