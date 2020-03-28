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

var controllerapeared = true
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
	update_weapons()


func update_weapons(upwards:bool = true):
	var ship = battle_units.SpaceShip
	if ship != null:
		if upwards:
			ship.Weapons.push_front(ship.Weapons.back())
			ship.Weapons.pop_back()
		else:
			ship.Weapons.push_back(ship.Weapons.front())
			ship.Weapons.pop_front()
			
		var dwdwwep = ship.Weapons[0].instance()
		var lowerWeapon = ship.Weapons[1].instance()
		var upperWeapon = ship.Weapons[3].instance()
		var upupwep = ship.Weapons[4].instance()
		ship.update_equipped_weapon(2)
		
		UpperButton.texture = upperWeapon.icon_texture
		LowerButton.texture = lowerWeapon.icon_texture
		upbtn2.texture = upupwep.icon_texture
		downbtn2.texture = dwdwwep.icon_texture
		
		upperWeapon.free()
		lowerWeapon.free()
		upupwep.free()
		dwdwwep.free()
		
		var weapon = ship.equipped_weapon
		weaponIcon.texture = weapon.icon_texture

		$NamePanel.show()
		$NamePanel/NameLabel.text = weapon._name
			
		
		

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
		if (event.position.x - init_posx) > 30:
			update_weapons(false)
			chanchange = false
			print("caca")
			emit_signal("weapon_Changed")
		elif (init_posx - event.position.x) > 30:
			update_weapons()
			chanchange = false
			emit_signal("weapon_Changed")
