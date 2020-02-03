extends Panel
onready var animation = $AnimationPlayer
onready var infLabel = $Inf
onready var tiitlePanel = $TittlePanel
var _animation = Animation.new()

func _ready():
	infLabel.hide()
	tiitlePanel.hide()

func _on_ActionButton_pressed():
	animation.play("PanelInfAppear")
	yield(animation, "animation_finished")
	infLabel.show()
	tiitlePanel.show()
	
	yield(get_tree().create_timer(6), "timeout")
	if animation.is_playing():
		yield(animation,"animation_finished")
		infLabel.hide()
		tiitlePanel.hide()
		animation.play("PanelInfDisappear")
	else:
		infLabel.hide()
		tiitlePanel.hide()
		animation.play("PanelInfDisappear")
