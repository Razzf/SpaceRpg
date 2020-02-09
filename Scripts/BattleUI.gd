extends Control

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var actionBtns = $ActionButtons
var weaponSelector = null
var load_scene = preload("res://Scenes/WeaponSelector.tscn")

signal turn_passed

func _on_ShowWeaponsBtn_pressed():
	actionBtns.hide()
	weaponSelector = load_scene.instance()
	add_child(weaponSelector)

func _on_PassTurnBtn_pressed():
	actionBtns.hide()
	emit_signal("turn_passed")

func _on_RunAwayBtn_pressed():
	actionBtns.hide()
	pass
	
func _ready():
	battle_units.BattleUI = self
# warning-ignore:return_value_discarded
	self.connect("turn_passed", self.get_parent(), "_on_BattleUI_turn_passed")
	
func _exit_tree():
	battle_units.BattleUI = null
