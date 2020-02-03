extends Panel
onready var animation = $AnimationPlayer
onready var TittleLabel = $TittlePanel/Tittle
onready var TittlePanel = $TittlePanel
onready var OkBtn = $OkBtn
onready var CancelBtn = $CancelBtn
var _animation = Animation.new()

func _ready():
	pass
	TittleLabel.hide()
	TittlePanel.hide()
	OkBtn.hide()
	CancelBtn.hide()

func _on_ActionBtn_pressed():
	animation.play("PanelAppear")
	yield(animation,"animation_finished")
	TittlePanel.show()
	TittleLabel.show()
	OkBtn.show()
	CancelBtn.show()


func _on_OkBtn_pressed():
	TittleLabel.hide()
	TittlePanel.hide()
	OkBtn.hide()
	CancelBtn.hide()
	animation.play("PanelDisappear")


func _on_CancelBtn_pressed():
	TittleLabel.hide()
	TittlePanel.hide()
	OkBtn.hide()
	CancelBtn.hide()
	animation.play("PanelDisappear")
