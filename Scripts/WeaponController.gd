extends Container

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var weaponIcon = $WeaponIcon/Sprite
onready var UpperButton = $UpDownBtns2/UpButton/icon
onready var LowerButton = $UpDownBtns2/DownButton/icon
onready var weaponnamepanel = get_parent().get_node("Panel")
onready var weaponName = get_parent().get_node("Panel/Label")
signal weapon_Changed()
const upwards = -1
const downwards = 1
var index = 0
var up_index = 1 
var down_index = 2

func _ready():
	$anim.play("Appear")
	yield($anim,"animation_finished")
	weaponnamepanel.show()
	if battle_units.SpaceShip != null and battle_units.SpaceShip.equipped_weapon != null:
		var ship = battle_units.SpaceShip
		var weapon = ship.equipped_weapon
		var upperWeapon = ship.Weapons[up_index].instance()
		var lowerWeapon = ship.Weapons[down_index].instance()
		
		UpperButton.texture = upperWeapon.icon_texture
		LowerButton.texture = lowerWeapon.icon_texture
		weaponIcon.texture = weapon.icon_texture
		weaponName.text = weapon._name
		upperWeapon.free()
		lowerWeapon.free()
		

func _on_UpButton_pressed(): #Moves the weapons downwards
	update_weapon_selector(downwards)
	emit_signal("weapon_Changed")

func _on_DownButton_pressed(): #moves the weapons upwards
	update_weapon_selector(upwards)
	emit_signal("weapon_Changed")

func update_weapon_selector(trace): #func that moves the weapon positions up or down
	var ship = battle_units.SpaceShip
	if ship != null:
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
	
			var upperWeapon = ship.Weapons[up_index].instance()
			var lowerWeapon = ship.Weapons[down_index].instance()
	
			UpperButton.texture = upperWeapon.icon_texture
			LowerButton.texture = lowerWeapon.icon_texture
			
			upperWeapon.free()
			lowerWeapon.free()
	
			ship.update_equipped_weapon(index)
			weapon = ship.equipped_weapon
			weaponnamepanel.show()
			weaponName.text = weapon._name
			weaponIcon.texture = weapon.icon_texture
			
func _weaponSelector_outspreded():
	if $anim.get_playing_speed() == -1:
		weaponnamepanel.hide()
		print("se hideo")
	else:
		weaponnamepanel.show()
		print("no se jaideo")
			


func _on_WeaponIcon_pressed():
	$anim.play_backwards("Appear")
	yield($anim, "animation_finished")
	battle_units.SpaceShip.attack(battle_units.Enemy)
	queue_free()
