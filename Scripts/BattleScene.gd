extends Node2D


onready var enemy = $"Spacial Tardigran"

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy.animation.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
