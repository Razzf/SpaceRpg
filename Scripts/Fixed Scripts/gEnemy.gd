extends Node2D
class_name Enemy

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

export(int)var max_hp
var hp setget sethp
export(int) var physical_damage

onready var animation : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite


signal dead
signal enemy_attacked
signal hp_changed(value)

func is_dead() -> bool:
	return hp <= 0
	
func tackle() -> void:
	animation.play("Attack")
	yield(animation,"animation_finished")
	emit_signal("enemy_attacked")

func deal_damage() -> void:
	battle_units.SpaceShip.take_damage(physical_damage, Vector2(global_position.x, global_position.y + 20))
	


	
func sethp(value):
	hp = value
	emit_signal("hp_changed", value)

func _ready():
	battle_units.Enemy = self
	$Sprite/HpBar.initialize(max_hp)

func _exit_tree():
	battle_units.Enemy = null


