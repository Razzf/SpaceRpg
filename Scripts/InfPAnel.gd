extends Panel
onready var animation = $AnimationPlayer
onready var TittleLabel = $TittlePanel/Tittle
onready var TittlePanel = $TittlePanel
onready var OkBtn = $OkBtn
onready var CancelBtn = $CancelBtn
onready var InfText = $InfText
onready var ActionBtns = $ActiobButtons
onready var weaponController = $WeaponController
var _animation = Animation.new()
var PanelAbleToAppear = true

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var weapon = battle_units.ShipStats.find_node("Weapon", true, false)
#onready var weapon = battle_units.ShipStats.find_node("Weapon", true, false)

func _ready():
	weaponController.hide()
	TittleLabel.hide()
	TittlePanel.hide()
	OkBtn.hide()
	CancelBtn.hide()
	InfText.hide()
	pass

func _on_OkBtn_pressed():
	TittleLabel.hide()
	TittlePanel.hide()
	OkBtn.hide()
	CancelBtn.hide()
	InfText.hide()
	animation.play("PanelDisappear")
	yield(animation,"animation_finished")
	weaponController.hide()
	PanelAbleToAppear = true
	var enemy = battle_units.Enemy
	var ship = battle_units.ShipStats
	if enemy != null and ship != null:
		enemy.take_damage(weapon.power)
		ship.energy -= weapon.cost
		ship.ap -= 1
		print("attacking")


func _on_CancelBtn_pressed():
	weaponController.hide()
	TittleLabel.hide()
	TittlePanel.hide()
	OkBtn.hide()
	CancelBtn.hide()
	InfText.hide()
	animation.play("PanelDisappear")
	yield(animation,"animation_finished")
	PanelAbleToAppear = true


func _on_Enemy_end_turn():
	weaponController.hide()
	TittleLabel.hide()
	TittlePanel.hide()
	OkBtn.hide()
	CancelBtn.hide()
	InfText.hide()
	ActionBtns.show()


func _on_WeaponController_weapon_Changed(weapon_selected):
	TittleLabel.text = weapon_selected._name


func _on_ShoWeaponsBtn_pressed():
	if PanelAbleToAppear:
		ActionBtns.hide()
		weaponController.show()
		animation.play("PanelAppear")
		yield(animation,"animation_finished")
		TittlePanel.show()
		TittleLabel.show()
		InfText.show()
		TittleLabel.text = weapon._name
		OkBtn.show()
		CancelBtn.show()
		PanelAbleToAppear = false
