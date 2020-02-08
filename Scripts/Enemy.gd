extends Node2D

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")


export(int) var hp = 1200 setget sethp
export(int) var damage = 4

onready var hp_label = $Label
onready var animation = $AnimationPlayer
onready var sprite = $Sprite



signal dead
signal enemy_atacked

func is_dead():
	return hp <= 0
	
func attack():
	animation.play("Attack")
	yield(animation,"animation_finished")
	emit_signal("enemy_atacked")

func deal_damage():
	battle_units.SpaceShip.shield -= damage
	
func take_damage(amount):
	self.hp -= amount
	if is_dead():
		queue_free()
		emit_signal("dead")
	else:
		animation.play("Shake")
		yield(animation,"animation_finished")
		animation.play("Idle")
	
func sethp(value):
	hp = value
	if hp_label != null:
		hp_label.text = str(hp) + "Hp"


func _ready():
	battle_units.Enemy = self

func _exit_tree():
	battle_units.Enemy = null
