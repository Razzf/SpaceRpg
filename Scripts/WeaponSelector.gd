extends Container

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

onready var descriptionPanel = $DescriptionPanel
onready var weaponController = $WeaponController
onready var panelAnimations = $DescriptionPanel/PanelAnimation
onready var weaponNamePanel = $DescriptionPanel/WeaponNamePanel
onready var weaponNameLabel = $DescriptionPanel/WeaponNamePanel/WeaponNameLabel
onready var weaponDescription = $DescriptionPanel/WeaponDescription
onready var btns = $BtnsContainer

signal weapon_used()

func _ready():
	weaponController.show()
	panelAnimations.play("PanelAppear")

func _on_OkBtn_pressed():
	btns.hide()
	weaponNamePanel.hide()
	weaponDescription.hide()
	panelAnimations.play("PanelDisappear")
	yield(panelAnimations,"animation_finished")
	weaponController.hide()
	descriptionPanel.hide()
	var enemy = battle_units.Enemy
	var ship = battle_units.SpaceShip
	if enemy != null and ship != null:
		var weapon = ship.equipped_weapon
		enemy.take_damage(weapon.power)
		ship.energy -= weapon.energy_cost
		emit_signal("weapon_used")


func _on_CancelBtn_pressed():
	btns.hide()
	weaponNamePanel.hide()
	weaponDescription.hide()
	panelAnimations.play("PanelDisappear")
	yield(panelAnimations,"animation_finished")
	weaponController.hide()
	descriptionPanel.hide()


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
