extends Panel
onready var animation = $AnimationPlayer
onready var TittleLabel = $TittlePanel/Tittle
onready var TittlePanel = $TittlePanel
onready var OkBtn = $OkBtn
onready var CancelBtn = $CancelBtn
var _animation = Animation.new()
var PanelAbleToAppear = true

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

func _ready():
	pass
	TittleLabel.hide()
	TittlePanel.hide()
	OkBtn.hide()
	CancelBtn.hide()

func _on_ActionBtn_pressed():
	if PanelAbleToAppear:
		animation.play("PanelAppear")
		yield(animation,"animation_finished")
		TittlePanel.show()
		TittleLabel.show()
		OkBtn.show()
		CancelBtn.show()
		PanelAbleToAppear = false
	


func _on_OkBtn_pressed():
	TittleLabel.hide()
	TittlePanel.hide()
	OkBtn.hide()
	CancelBtn.hide()
	animation.play("PanelDisappear")
	yield(animation,"animation_finished")
	PanelAbleToAppear = true
	var enemy = battle_units.Enemy
	var ship = battle_units.ShipStats
	if enemy != null and ship != null:
		enemy.take_damage(120)
		ship.energy -= 200
		ship.ap -= 1
		print("attacking")


func _on_CancelBtn_pressed():
	TittleLabel.hide()
	TittlePanel.hide()
	OkBtn.hide()
	CancelBtn.hide()
	animation.play("PanelDisappear")
	yield(animation,"animation_finished")
	PanelAbleToAppear = true
