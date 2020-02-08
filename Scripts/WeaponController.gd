extends CenterContainer

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var weaponIcon = $WeaponIcon/Sprite
onready var UpperButton = $UpDownBtns/UpButton
onready var LowerButton = $UpDownBtns/DownButton
signal weapon_Changed()
const upwards = -1
const downwards = 1
var index = 0
var up_index = 1 
var down_index = 2

func _ready():
	var ship = battle_units.SpaceShip
	if ship != null:
		var weapon = ship.Weapons[index].instance()
		weaponIcon.texture = weapon.icon_texture
		UpperButton.icon = ship.Weapons[up_index].instance().icon_texture
		LowerButton.icon = ship.Weapons[down_index].instance().icon_texture

func _on_UpButton_pressed(): #Moves the weapons downwards
	update_weapon_selector(downwards)
	

func _on_DownButton_pressed(): #moves the weapons upwards
	update_weapon_selector(upwards)

func update_weapon_selector(trace): #func that moves the weapon positions up or down
	var ship = battle_units.SpaceShip
	

	if ship.find_node("Weapon", true, false) != null:
		var weapon = ship.get_node("Weapon")
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

		ship.update_equipped_weapon(index)
		weapon = ship.equipped_weapon
		emit_signal("weapon_Changed")
		weaponIcon.texture = weapon.icon_texture




	
	

