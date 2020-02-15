extends Container

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var animation = $AnimationPlayer
var weaponSelector = null
var load_scene = preload("res://Scenes/WeaponSelector.tscn")

signal turn_passed

func _on_ShowWeaponsBtn_pressed() -> void:
	animation.play_backwards("ActionBtnsAppear")
	yield(animation,"animation_finished")
	weaponSelector = load_scene.instance()
	get_parent().add_child(weaponSelector)


func _on_PassTurnBtn_pressed() -> void:
	emit_signal("turn_passed")
	animation.play_backwards("ActionBtnsAppear")
	yield(animation,"animation_finished")
	free()

func _on_RunAwayBtn_pressed() -> void:
	animation.play_backwards("ActionBtnsAppear")
	yield(animation,"animation_finished")
	free()
	
func _ready():
	print("creating action btns")
	yield(get_tree().create_timer(.5),"timeout")
	animation.play("ActionBtnsAppear")
# warning-ignore:return_value_discarded
	self.connect("turn_passed", self.get_parent().get_parent(), "_on_BattleUI_turn_passed")
	
func _exit_tree():
	print("saliendooo")
