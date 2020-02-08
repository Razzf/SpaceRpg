extends Container

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

onready var descriptionPanel = $DescriptionPanel
onready var weaponController = $WeaponController
onready var panelAnimations = $DescriptionPanel/PanelAnimation
onready var weaponNamePanel = $DescriptionPanel/WeaponNamePanel
onready var weaponNameLabel = $DescriptionPanel/WeaponNamePanel/WeaponNameLabel
onready var weaponDescription = $DescriptionPanel/WeaponDescription
onready var btns = $BtnsContainer
onready var okBtn = $BtnsContainer/OkBtn

func _ready():
	if battle_units.BattleUI != null:
		battle_units.BattleUI.actionBtns.hide()
		weaponController.show()
		descriptionPanel.show()
		panelAnimations.play("PanelAppear")
		yield(panelAnimations,"animation_finished")
		btns.show()
		weaponNamePanel.show()
		weaponDescription.show()

func _on_OkBtn_pressed():
	btns.hide()
	weaponNamePanel.hide()
	weaponDescription.hide()
	panelAnimations.play("PanelDisappear")
	yield(panelAnimations,"animation_finished")
	weaponController.hide()
	descriptionPanel.hide()
	queue_free()

func _on_CancelBtn_pressed():
	btns.hide()
	weaponNamePanel.hide()
	weaponDescription.hide()
	panelAnimations.play("PanelDisappear")
	yield(panelAnimations,"animation_finished")
	weaponController.hide()
	descriptionPanel.hide()
	queue_free()


func _on_Enemy_enemy_atacked():
	weaponController.show()
	descriptionPanel.show()
	panelAnimations.play("PanelAppear")
	yield(panelAnimations,"animation_finished")
	btns.show()
	weaponNamePanel.show()
	weaponDescription.show()

func _on_WeaponController_weapon_Changed():
	weaponNameLabel.text = battle_units.SpaceShip.equipped_weapon._name
	
func _exit_tree():
	if battle_units.BattleUI != null:
		battle_units.BattleUI.actionBtns.show()
