extends PanelContainer


onready var animation = $Panel/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ActionBtn_pressed():
	animation.play("PanelAppear")
	yield(animation, "animation_finished")
	animation.play("PanelDisappear")
