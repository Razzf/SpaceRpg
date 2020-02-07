extends CenterContainer

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var weaponIcon = $WeaponIcon/Sprite
onready var UpperButton = $UpDownBtns/UpButton
onready var LowerButton = $UpDownBtns/DownButton
signal weapon_Changed(weapon_selected)
var index = 0
var up_index = 1 
var down_index = 2

func _ready():
	var ship = battle_units.ShipStats
	var weapon = ship.Weapons[index].instance()
	weaponIcon.texture = weapon.icon_texture
	UpperButton.icon = ship.Weapons[up_index].instance().icon_texture
	LowerButton.icon = ship.Weapons[down_index].instance().icon_texture

func _on_UpButton_pressed(): #Moves the weapons downwards
	twist_weapons(1)
	

func _on_DownButton_pressed(): #moves the weapons upwards
	twist_weapons(-1)
	
	
			
func update_weapon(w_index): #func that updates the actual weapon of the ship
	var ship = battle_units.ShipStats
	var weapon = ship.get_node("Weapon")
	ship.remove_child(weapon)
	ship.add_child(ship.Weapons[w_index].instance())
	weapon = ship.get_node("Weapon")
	emit_signal("weapon_Changed", weapon)
	weaponIcon.texture = weapon.icon_texture

func twist_weapons(trace): #func that moves the weapon positions up or down
	var ship = battle_units.ShipStats
	if ship.find_node("Weapon", true, false) != null:
		index = index + 1 * (trace)
		up_index = up_index + 1 * (trace)
		down_index = down_index + 1 * (trace)
		if index == ship.Weapons.size() * (trace):
			index = 0
			up_index = 1
			down_index = 2
		elif up_index == ship.Weapons.size() * (trace):
			index = 2
			up_index = 0
			down_index = 1
		elif down_index == ship.Weapons.size() * (trace):
			index = 1
			up_index = 2
			down_index = 0

		UpperButton.icon = ship.Weapons[up_index].instance().icon_texture
		LowerButton.icon = ship.Weapons[down_index].instance().icon_texture

		update_weapon(index)




	
	

