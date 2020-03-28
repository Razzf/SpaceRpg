extends Control

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")
onready var weaponIcon = $WeaponIcon/Sprite
onready var centerbtn = $WeaponIcon
onready var upbtn = $UpDownBtns2/UpButton
onready var downbtn = $UpDownBtns2/DownButton
onready var upperbtn2 = $UpDownBtns/UpButton
onready var lowerbtn2 = $UpDownBtns/DownButton
onready var upbtn2 = $UpDownBtns/UpButton/icon
onready var downbtn2 = $UpDownBtns/DownButton/icon
onready var UpperButton = $UpDownBtns2/UpButton/icon
onready var LowerButton = $UpDownBtns2/DownButton/icon

signal weapon_Changed()
const upwards = -1
const downwards = 1

var WpnIdxs

var downdown_index = 0
var down_index = 1
var index = 2
var up_index = 3
var upup_index = 4

var controllerapeared = true
var inreact = true
var chanchange = true

var dragging = false
var click_radius = 80
var init_posx

func _ready():
	$anim.play("Appear")
	yield($anim,"animation_finished")
	controllerapeared = true
	centerbtn.disabled = false
	
	$NamePanel.show()
	if battle_units.SpaceShip != null and battle_units.SpaceShip.equipped_weapon != null:
		var ship = battle_units.SpaceShip
		
		var dwnbt2 = ship.Weapons[downdown_index].instance()
		var lowerWeapon = ship.Weapons[down_index].instance()
		var weapon = ship.equipped_weapon
		var upperWeapon = ship.Weapons[up_index].instance()
		var upbt2 = ship.Weapons[upup_index].instance()
		
		downbtn2.texture = dwnbt2.icon_texture
		LowerButton.texture = lowerWeapon.icon_texture
		weaponIcon.texture = weapon.icon_texture
		UpperButton.texture = upperWeapon.icon_texture
		upbtn2.texture = upbt2.icon_texture
		
		$NamePanel/NameLabel.text = weapon._name
		upperWeapon.free()
		lowerWeapon.free()
		upbt2.free()
		dwnbt2.free()
		
func update_weapon_selector(trace): #func that moves the weapon positions up or down
	var ship = battle_units.SpaceShip
	if ship != null:
		if ship.find_node("Weapon", true, false) != null:
			var weapon = ship.get_node("Weapon")
			downdown_index = downdown_index + 1 *(trace)
			down_index = down_index + 1 * (trace)
			index = index + 1 * (trace)
			up_index = up_index + 1 * (trace)
			upup_index = upup_index + 1 *(trace)
			if downdown_index  == ship.Weapons.size() * (trace):
				downdown_index = 0
				down_index = 1
				index = 2
				up_index = 3
				upup_index = 4
			elif down_index == ship.Weapons.size() * (trace):
				downdown_index = 4
				down_index = 0
				index = 1
				up_index = 2
				upup_index = 3
			elif index == ship.Weapons.size() * (trace):
				downdown_index = 3
				down_index = 4
				index = 0
				up_index = 1
				upup_index = 2
			elif up_index == ship.Weapons.size() * (trace):
				downdown_index = 2
				down_index = 3
				index = 4
				up_index = 0
				upup_index = 1
			elif upup_index == ship.Weapons.size() * (trace):
				downdown_index = 1
				down_index = 2
				index = 3
				up_index = 4
				upup_index = 0
				
			var upperWeapon = ship.Weapons[up_index].instance()
			var lowerWeapon = ship.Weapons[down_index].instance()
			var upupwep = ship.Weapons[upup_index].instance()
			var dwdwwep = ship.Weapons[downdown_index].instance()
	
			UpperButton.texture = upperWeapon.icon_texture
			LowerButton.texture = lowerWeapon.icon_texture
			upbtn2.texture = upupwep.icon_texture
			downbtn2.texture = dwdwwep.icon_texture
			
			upperWeapon.free()
			lowerWeapon.free()
			upupwep.free()
			dwdwwep.free()
			
			ship.update_equipped_weapon(index)
			weapon = ship.equipped_weapon
			$NamePanel.show()
			$NamePanel/NameLabel.text = weapon._name
			weaponIcon.texture = weapon.icon_texture
			
func update_test():
	pass
	
			
func _weaponSelector_outspreded():
	if $anim.get_playing_speed() == -1:
		$NamePanel.hide()
	else:
		$NamePanel.show()
		
func _on_WeaponIcon_pressed():
	centerbtn.disabled = true
	controllerapeared = false
	$anim.play_backwards("Appear")
	yield($anim, "animation_finished")
	battle_units.SpaceShip.attack(battle_units.Enemy)
	queue_free()


func _gui_input(event):
	
	if event is InputEventScreenTouch:
		init_posx = event.position.x
		if !dragging and event.pressed:
			dragging = true

		if dragging and !event.pressed:
			chanchange = true
			dragging = false

	if event is InputEventScreenDrag and dragging and chanchange:
		if (event.position.x - init_posx) > 40:
			update_weapon_selector(downwards)
			chanchange = false
			print("caca")
			emit_signal("weapon_Changed")
			
		elif (init_posx - event.position.x) > 40:
			update_weapon_selector(upwards)
			chanchange = false
			emit_signal("weapon_Changed")
