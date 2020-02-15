extends Container

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

onready var descriptionPanel = $DescriptionPanel
onready var weaponController = $WeaponController
onready var panelAnimations = $DescriptionPanel/PanelAnimation
onready var weaponNamePanel = $DescriptionPanel/WeaponNamePanel
onready var weaponNameLabel = $DescriptionPanel/WeaponNamePanel/WeaponNameLabel
onready var weaponDescription = $DescriptionPanel/WeaponDescription
onready var btns = $BtnsContainer

signal weapon_selected

func _ready():
	if battle_units.SpaceShip != null:
		var weapon = battle_units.SpaceShip.equipped_weapon
		weaponNameLabel.text = weapon._name
		weaponDescription.text = weapon.get_description()
		if battle_units.BattleUI != null:
			#battle_units.BattleUI.actionBtns.hide()
			weaponController.show()
			panelAnimations.play("PanelAppear")
			descriptionPanel.show()
			yield(panelAnimations,"animation_finished")
			btns.show()
			weaponNameLabel.show()
			weaponNamePanel.show()
			weaponDescription.show()
			btns.show()

func _on_OkBtn_pressed():
	btns.hide()
	weaponNamePanel.hide()
	weaponDescription.hide()
	panelAnimations.play_backwards("PanelAppear")
	yield(panelAnimations,"animation_finished")
	battle_units.SpaceShip.attack(battle_units.Enemy)
	emit_signal("weapon_selected")
	queue_free()

func _on_CancelBtn_pressed():
	btns.hide()
	weaponNamePanel.hide()
	weaponDescription.hide()
	panelAnimations.play_backwards("PanelAppear")
	yield(panelAnimations,"animation_finished")
	queue_free()

func _on_WeaponController_weapon_Changed():
	var weapon = battle_units.SpaceShip.equipped_weapon
	if weapon != null:
		weaponNameLabel.text = weapon._name
		weaponDescription.text = weapon.get_description()
