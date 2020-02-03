extends Button

export(Array, Image) var icons = []
var index = 0


func _ready():
	icon = icons[index]

func _on_UpButton_pressed():
	index = index - 1
	
	
	if index <= -4 or index >= 4:
		index = 0
		
	icon = icons[index]

func _on_DownButton_pressed():
	index = index + 1
	
	if index <= -4 or index >= 4:
		index = 0
		
	icon = icons[index]
