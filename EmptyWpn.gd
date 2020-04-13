extends Node2D

export(Texture) var icon_texture
var is_empty = true
onready var _name = self.name

func _ready():
	name = "Weapon"
