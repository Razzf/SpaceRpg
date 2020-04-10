extends Node2D

var init_posx = 0
export(float, 1, 100) var touch_sensitivity
var fixed_sensitivity

func _ready():
	fixed_sensitivity = 100 - touch_sensitivity


func _on_Area2D_input_event(viewport, event, shape_idx):
	
	if event is InputEventScreenTouch:
		init_posx = event.position.x 
	if event is InputEventScreenDrag:
		var difference = init_posx - event.position.x
		if difference >= fixed_sensitivity:
			print("moved to left")
		elif difference <= -fixed_sensitivity:
			print("moved to right")
