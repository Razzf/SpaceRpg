extends Control

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var animation = $AnimationPlayer
var weaponSelector = null
var load_scene = preload("res://Scenes/Battle/Control/WeaponSelector.tscn")

signal turn_passed

func _on_ShowWeaponsBtn_pressed() -> void:
	print("weapons btn pressed")
	animation.play_backwards("ActionBtnsAppear")
	enoridsbtns(true)
	yield(animation,"animation_finished")
	weaponSelector = load_scene.instance()
	get_parent().add_child(weaponSelector)
	queue_free()


func _on_PassTurnBtn_pressed() -> void:
	print("pass btn pressed")
	emit_signal("turn_passed")
	animation.play_backwards("ActionBtnsAppear")
	enoridsbtns(true)
	yield(animation,"animation_finished")
	queue_free()

func _on_RunAwayBtn_pressed() -> void:
	print("runaway btn pressed")
	animation.play_backwards("ActionBtnsAppear")
	enoridsbtns(true)
	yield(animation,"animation_finished")
	queue_free()
	
func _ready():
	enoridsbtns(false)
	animation.play("ActionBtnsAppear")
# warning-ignore:return_value_discarded
	self.connect("turn_passed", self.get_parent().get_parent(), "_on_BattleUI_turn_passed")
	
	
func enoridsbtns(bulean):
	$PassTurnBtn.disabled = bulean
	$ShowWeaponsBtn.disabled = bulean
	$RunAwayBtn.disabled = bulean
