extends Control

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

signal weapon_Changed()

export(float, 0.1, 100) var sensitivity 

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
	update_module()

func update_module(upwards:bool = true) -> void:
	var ship = battle_units.SpaceShip
	if ship != null:
		if !upwards:
			ship.actual_module.push_front(ship.actual_module.back())
			ship.actual_module.pop_back()
		else:
			ship.actual_module.push_back(ship.actual_module.front())
			ship.actual_module.pop_front()
			
		for w_idx in range(0, ship.actual_module.size()):
			var extra_weapon = ship.actual_module[w_idx].instance()
			wpn_icons[w_idx].texture = extra_weapon.icon_texture
			extra_weapon.queue_free()
			
		ship.update_equipped_weapon(2)
		var weapon = ship.equipped_weapon
		$WeaponIcon/Sprite.texture = weapon.icon_texture
		$NamePanel/NameLabel.text = weapon._name

func _weaponSelector_outspreded():
	if $anim.get_playing_speed() == -1:
		$NamePanel.hide()
		$PassBtn.hide()
		$RunBtn.hide()
	else:
		$NamePanel.show()
		$PassBtn.show()
		$RunBtn.show()

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
		var weapon = battle_units.SpaceShip.equipped_weapon
		var wpn_anim = weapon.find_node("AnimationPlayer", true, false)
		if !wpn_anim.is_playing():
			if difference >= (100-sensitivity):
				init_posx = event.position.x
				update_module(false)
				emit_signal("weapon_Changed")
			if difference <= - (100-sensitivity):
				init_posx = event.position.x
				update_module()
				emit_signal("weapon_Changed")


func _on_PassBtn_pressed():
	$PassBtn.disabled = true
	$RunBtn.disabled = true
	$WeaponIcon.disabled = true
	controllerapeared = false
	$anim.play_backwards("Appear")
	yield($anim, "animation_finished")
	queue_free()


func _on_RunBtn_pressed():
	$PassBtn.disabled = true
	$RunBtn.disabled = true
	$WeaponIcon.disabled = true
	controllerapeared = false
	$anim.play_backwards("Appear")
	yield($anim, "animation_finished")
	queue_free()
	battle_units.SpaceShip.wea()
