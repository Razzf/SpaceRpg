extends Control

const battle_units = preload("res://Resources/ScriptableClasses/BattleUnits.tres")

signal weapon_Changed()

export(float, 0.01, 1) var touch_sensitivity
export(bool) var reiterative
var init_vec = Vector2.ZERO
var swipe_direction = Vector2.ZERO
var swipe_length = Vector2.ZERO
var fixed_sens
var can_swipe = false
signal swiped(direction)
var can_rotate = false

onready var wpn_icons = [$WeaponIcon/Sprite, $UpDownBtns2/DownButton/icon, $UpDownBtns/DownButton/icon,
				$UpDownBtns/UpButton/icon, $UpDownBtns2/UpButton/icon]

func _ready():
	fixed_sens = 101 - ((touch_sensitivity) * 100)

func appear():
	$anim.play("Appear")
	yield($anim,"animation_finished")
	enable_use()
	update_wpn_selector()

func disappear():
	disable_use()
	$anim.play_backwards("Appear")
	yield($anim,"animation_finished")
	


func rotate_weapons(right:bool = true) -> void:
	var ship = battle_units.SpaceShip
	if ship != null:
		if !right:
			ship.weapons.push_front(ship.weapons.back())
			ship.weapons.pop_back()
		else:
			ship.weapons.push_back(ship.weapons.front())
			ship.weapons.pop_front()
			
		
			
		

func update_wpn_selector():
	var ship = battle_units.SpaceShip
	if ship != null:
		for w_idx in range(0, ship.weapons.size()):
			var extra_weapon = ship.weapons[w_idx]
			wpn_icons[w_idx].texture = extra_weapon.icon_texture
		$NamePanel/NameLabel.text = ship.weapons.front().name


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
	disable_use()
	battle_units.SpaceShip.attack(battle_units.Enemies.actual_enemy)
	


func _on_PassBtn_pressed():
	pass


func _on_RunBtn_pressed():
	battle_units.SpaceShip.pass_attack()
	$RunBtn.disabled = true
	yield(battle_units.SpaceShip, "weapon_updated")
	$RunBtn.disabled = false

func enable_use():
	$WeaponIcon.disabled = false
	can_rotate = true

func disable_use():
	$WeaponIcon.disabled = true
	can_rotate = false


func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			init_vec = event.position
			can_swipe = true
		else:
			can_swipe = false
		
	if event is InputEventScreenDrag and can_swipe:
		
		swipe_direction = init_vec.direction_to(event.position).round()
		swipe_length =  init_vec.distance_to(event.position)
		
		var equipped_wpn = battle_units.SpaceShip.equipped_weapon
		var weapon_anim = equipped_wpn.find_node("AnimationPlayer", true, false)
		if can_rotate:
			if not equipped_wpn.playing_anim:
				if swipe_length >= fixed_sens:
					if reiterative:
						init_vec = event.position
					else:
						can_swipe = false
					if swipe_direction == Vector2.RIGHT:
						rotate_weapons(false)
						update_wpn_selector()
						emit_signal("weapon_Changed")
					elif swipe_direction == Vector2.LEFT:
						rotate_weapons()
						update_wpn_selector()
						emit_signal("weapon_Changed")
					emit_signal("swiped", swipe_direction)
