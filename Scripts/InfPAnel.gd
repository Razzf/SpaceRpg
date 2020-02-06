extends Panel
onready var animation = $AnimationPlayer
onready var TittleLabel = $TittlePanel/Tittle
onready var TittlePanel = $TittlePanel
onready var OkBtn = $OkBtn
onready var CancelBtn = $CancelBtn
onready var InfText = $InfText
var _animation = Animation.new()
var PanelAbleToAppear = true

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var weapon = battle_units.ShipStats.get_child(0)

func _ready():
	print(str(weapon))
	pass
	TittleLabel.hide()
	TittlePanel.hide()
	OkBtn.hide()
	CancelBtn.hide()
	InfText.hide()

func _on_ActionBtn_pressed():
	if PanelAbleToAppear:
		animation.play("PanelAppear")
		yield(animation,"animation_finished")
		TittlePanel.show()
		TittleLabel.show()
		InfText.show()
		TittleLabel.text = weapon.name

		OkBtn.show()
		CancelBtn.show()
		PanelAbleToAppear = false
	


func _on_OkBtn_pressed():
	TittleLabel.hide()
	TittlePanel.hide()
	OkBtn.hide()
	CancelBtn.hide()
	InfText.hide()
	animation.play("PanelDisappear")
	yield(animation,"animation_finished")
	PanelAbleToAppear = true
	var enemy = battle_units.Enemy
	var ship = battle_units.ShipStats
	if enemy != null and ship != null:
		enemy.take_damage(ship.Weapon.power)
		ship.energy -= 200
		ship.ap -= 1
		print("attacking")


func _on_CancelBtn_pressed():
	TittleLabel.hide()
	TittlePanel.hide()
	OkBtn.hide()
	CancelBtn.hide()
	InfText.hide()
	animation.play("PanelDisappear")
	yield(animation,"animation_finished")
	PanelAbleToAppear = true
