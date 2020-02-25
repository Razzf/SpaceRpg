extends TouchScreenButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		print("cacaaaaas")
		add_child(preload("res://Scenes/ShootingScenes/Explosive Shot.tscn").instance())
		get_child(0).global_position = event.position
