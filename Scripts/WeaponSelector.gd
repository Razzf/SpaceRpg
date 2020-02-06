extends CenterContainer

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

onready var weaponIcon = $WeaponIcon/Sprite

var index = 0

func _ready():
	print(str(battle_units.ShipStats.get_child(0).icon_texture))
	weaponIcon.texture = battle_units.ShipStats.get_child(0).icon_texture

func _on_UpButton_pressed():
	index = index - 1
	if index <= -3 :
		index = 0
	var weaponSelected = battle_units.ShipStats.Weapons[index].instance()
	weaponIcon.texture = weaponSelected.icon_texture

func _on_DownButton_pressed():
	index = index + 1
	if index >= 3 || index <= 0:
		index = 0
	var weaponSelected = battle_units.ShipStats.Weapons[index].instance()
	weaponIcon.texture = weaponSelected.icon_texture
