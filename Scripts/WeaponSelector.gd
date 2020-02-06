extends CenterContainer

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var weaponIcon = $WeaponIcon/Sprite
signal weapon_Changed(weapon_selected)
var index = 0

func _ready():
	var ship = battle_units.ShipStats
	var weapon = ship.Weapons[index].instance()
	weaponIcon.texture = weapon.icon_texture
	pass

func _on_UpButton_pressed():
	if battle_units.ShipStats.find_node("Weapon", true, false) != null:
		var ship = battle_units.ShipStats
		index = index + 1
		if index == ship.Weapons.size():
			index = 0
		update_weapon(index)

func _on_DownButton_pressed():
	if battle_units.ShipStats.find_node("Weapon", true, false) != null:
		var ship = battle_units.ShipStats
		index = index - 1
		if index == - ship.Weapons.size():
			index = 0
		update_weapon(index)
			
func update_weapon(w_index):
	var ship = battle_units.ShipStats
	var weapon = ship.get_node("Weapon")
	ship.remove_child(weapon)
	ship.add_child(ship.Weapons[w_index].instance())
	weapon = ship.get_node("Weapon")
	emit_signal("weapon_Changed", weapon)
	weaponIcon.texture = weapon.icon_texture



	
	

