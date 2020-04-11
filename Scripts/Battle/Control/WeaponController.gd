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

var controllerapeared = true

onready var wpn_icons = [$UpDownBtns/UpButton/icon, $UpDownBtns2/UpButton/icon, $WeaponIcon/Sprite,
				$UpDownBtns2/DownButton/icon,$UpDownBtns/DownButton/icon]
	
func _ready():
	fixed_sens = 101 - ((touch_sensitivity) * 100)
	$anim.play("Appear")
	yield($anim,"animation_finished")
	controllerapeared = true
	$WeaponIcon.disabled = false
	$NamePanel.show()
	update_module()
	disappear()

func update_module(upwards:bool = true) -> void:
	var ship = battle_units.SpaceShip
	if ship != null:
		if !upwards:
			ship.weapons.push_front(ship.weapons.back())
			ship.weapons.pop_back()
		else:
			ship.weapons.push_back(ship.weapons.front())
			ship.weapons.pop_front()
			
		for w_idx in range(0, ship.weapons.size()):
			var extra_weapon = ship.weapons[w_idx].instance()
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
	yield(battle_units.SpaceShip.equipped_weapon, "on_used")
	$anim.play("Appear")
	yield($anim, "animation_finished")
	$WeaponIcon.disabled = false


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
		if !battle_units.SpaceShip.equipped_weapon.get_node("AnimationPlayer").is_playing():
			if swipe_length >= fixed_sens:
				if reiterative:
					init_vec = event.position
				else:
					can_swipe = false
				emit_signal("swiped", swipe_direction)
				if swipe_direction == Vector2.RIGHT:
					update_module(false)
					emit_signal("weapon_Changed")
				elif swipe_direction == Vector2.LEFT:
					update_module()
					emit_signal("weapon_Changed")

func disappear():
	yield(battle_units.SpaceShip, "end_turn")
	$anim.play_backwards("Appear")
	appear()
	
func appear():
	yield(battle_units.Enemy, "end_turn")
	$anim.play("Appear")
	disappear()

