extends Node2D
class_name Enemy

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")


export(int) var hp = 1200 setget sethp
export(int) var damage = 4

onready var hp_label : Label = $Label
onready var animation : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite

signal dead
signal enemy_atacked

func is_dead() -> bool:
	return hp <= 0
	
func attack() -> void:
	animation.play("Attack")
	yield(animation,"animation_finished")
	emit_signal("enemy_atacked")

func deal_damage() -> void:
	battle_units.SpaceShip.shield -= damage
	
func take_damage(amount) -> void:
	self.hp -= amount
	if is_dead():
		animation.play("Shake")
		yield(animation,"animation_finished")
		queue_free()
		emit_signal("dead")
	else:
		animation.play("Shake")
	
func sethp(value):
	hp = value
	if hp_label != null:
		hp_label.text = str(hp) + "Hp"


func _ready():
	battle_units.Enemy = self

func _exit_tree():
	battle_units.Enemy = null
