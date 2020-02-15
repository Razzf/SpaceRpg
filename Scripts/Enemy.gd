extends Node2D
class_name Enemy

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

var max_hp = 1200
export(int) var hp = 1200 setget sethp
export(int) var damage = 4

onready var hp_label : Label = $Label
onready var animation : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite
onready var progressbar : ProgressBar = $ProgressBar

signal dead
signal enemy_atacked

func is_dead() -> bool:
	return hp <= 0
	
func attack() -> void:
	battle_units.SpaceShip.shield_hitted_sprites.self_modulate = Color(0,0,0,0)
	battle_units.SpaceShip.shield_hitted_sprites.show()
	animation.play("Attack")
	yield(animation,"animation_finished")
	emit_signal("enemy_atacked")

func deal_damage() -> void:
	battle_units.SpaceShip.shield -= damage
	battle_units.SpaceShip.animation.play("Shield_Hitted")
	
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
	if progressbar != null:
		var pvalue
		pvalue = (100 * hp) / max_hp
		progressbar.value = pvalue
	if hp_label != null:
		hp_label.text = str(hp) + "Hp"


func _ready():
	battle_units.Enemy = self

func _exit_tree():
	battle_units.Enemy = null
