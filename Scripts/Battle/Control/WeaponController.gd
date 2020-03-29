extends Control

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

signal weapon_Changed()

var controllerapeared = true

var init_posx

onready var wpn_icons = [$UpDownBtns/UpButton/icon, $UpDownBtns2/UpButton/icon, $WeaponIcon/Sprite,
				$UpDownBtns2/DownButton/icon,$UpDownBtns/DownButton/icon]
	
func _ready():
	$anim.play("Appear")
	yield($anim,"animation_finished")
	controllerapeared = true
	$WeaponIcon.disabled = false
	$NamePanel.show()
	update_weapons()

func update_weapons(upwards:bool = true) -> void:
	var ship = battle_units.SpaceShip
	if ship != null:
		if !upwards:
			ship.Weapons.push_front(ship.Weapons.back())
			ship.Weapons.pop_back()
		else:
			ship.Weapons.push_back(ship.Weapons.front())
			ship.Weapons.pop_front()
			
		for w_idx in range(0, ship.Weapons.size()):
			var extra_weapon = ship.Weapons[w_idx].instance()
			wpn_icons[w_idx].texture = extra_weapon.icon_texture
			extra_weapon.queue_free()
			
		ship.update_equipped_weapon(2)
		var weapon = ship.equipped_weapon
		$WeaponIcon/Sprite.texture = weapon.icon_texture
		$NamePanel.show()
		$NamePanel/NameLabel.text = weapon._name

func _weaponSelector_outspreded():
	if $anim.get_playing_speed() == -1:
		$NamePanel.hide()
	else:
		$NamePanel.show()

func _on_WeaponIcon_pressed():
	$WeaponIcon.disabled = true
	controllerapeared = false
	$anim.play_backwards("Appear")
	yield($anim, "animation_finished")
	battle_units.SpaceShip.attack(battle_units.Enemy)
	queue_free()

func _gui_input(event):
	if event is InputEventScreenTouch:
		init_posx = event.position.x

	if event is InputEventScreenDrag:
		var difference = event.position.x - init_posx
		if difference >= 28:
			init_posx = event.position.x
			update_weapons(false)
			emit_signal("weapon_Changed")
		if difference <= -28:
			init_posx = event.position.x
			update_weapons()
			emit_signal("weapon_Changed")
