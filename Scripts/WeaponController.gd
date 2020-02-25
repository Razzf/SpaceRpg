extends Container

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
onready var weaponnamepanel = get_parent().get_node("Panel")
onready var weaponName = get_parent().get_node("Panel/Label")
signal weapon_Changed()
const upwards = -1
const downwards = 1
var index = 0
var up_index = 1 
var down_index = 3
var upup_index = 2
var downdown_index = 4

var controllerapeared = false
var inreact = false
var chanchange = true


var dragging = false
var click_radius = 80  # Size of the sprite
var init_posx

func _input(event):
	if event is InputEventScreenTouch:
		print("asu")
		if inreact:
			print("caca")
			init_posx = event.position.x
			# Start dragging if the click is on the sprite.
			if !dragging and event.pressed:
				dragging = true
		# Stop dragging if the button is released.
		if dragging and !event.pressed:
			chanchange = true
			dragging = false

	if event is InputEventScreenDrag and dragging and chanchange:
		if (event.position.x - init_posx) > 40:
			print("pa la derecha aaaaa")
			update_weapon_selector(downwards)
			chanchange = false
			emit_signal("weapon_Changed")

		
		elif (init_posx - event.position.x) > 40:
			print("pa la izquierda jasjasj")
			update_weapon_selector(upwards)
			chanchange = false
			emit_signal("weapon_Changed")

			
		
func _ready():
	$anim.play("Appear")
	yield($anim,"animation_finished")
	controllerapeared = true
	upbtn.disabled = false
	downbtn.disabled = false
	lowerbtn2.disabled = false
	upperbtn2.disabled = false
	centerbtn.disabled = false
	
	weaponnamepanel.show()
	if battle_units.SpaceShip != null and battle_units.SpaceShip.equipped_weapon != null:
		var ship = battle_units.SpaceShip
		var weapon = ship.equipped_weapon
		var upperWeapon = ship.Weapons[up_index].instance()
		var lowerWeapon = ship.Weapons[down_index].instance()
		var upbt2 = ship.Weapons[upup_index].instance()
		var dwnbt2 = ship.Weapons[downdown_index].instance()
		
		UpperButton.texture = upperWeapon.icon_texture
		upbtn2.texture = upbt2.icon_texture
		downbtn2.texture = dwnbt2.icon_texture
		LowerButton.texture = lowerWeapon.icon_texture
		weaponIcon.texture = weapon.icon_texture
		
		weaponName.text = weapon._name
		upperWeapon.free()
		lowerWeapon.free()
		upbt2.free()
		dwnbt2.free()
		

func _on_UpButton_pressed():
	pass
	

func _on_DownButton_pressed():
	pass
	

func update_weapon_selector(trace): #func that moves the weapon positions up or down
	var ship = battle_units.SpaceShip
	if ship != null:
		if ship.find_node("Weapon", true, false) != null:
			var weapon = ship.get_node("Weapon")
			index = index + 1 * (trace)
			up_index = up_index + 1 * (trace)
			down_index = down_index + 1 * (trace)
			upup_index = upup_index + 1 *(trace)
			downdown_index = down_index + 1 *(trace)
			if index == ship.Weapons.size() * (trace):
				index = 0
				up_index = 1
				upup_index = 2
				down_index = 3
				downdown_index =4
				
			elif up_index == ship.Weapons.size() * (trace):
				index = 4
				up_index = 0
				upup_index = 1
				down_index = 2
				downdown_index = 3
			elif down_index == ship.Weapons.size() * (trace):
				index = 3
				up_index = 1
				upup_index =2
				down_index = 4
				downdown_index = 0
	
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
	upbtn.disabled = true
	downbtn.disabled = true
	lowerbtn2.disabled = true
	upperbtn2.disabled = true
	centerbtn.disabled = true
	controllerapeared = false
	$anim.play_backwards("Appear")
	yield($anim, "animation_finished")
	battle_units.SpaceShip.attack(battle_units.Enemy)
	queue_free()


func _on_WeaponController_mouse_entered():
	if controllerapeared:
		inreact = true
		print("caca lista")
		


func _on_WeaponController_mouse_exited():
	print("salio")
	if controllerapeared:
		inreact = false
		pass


func _on_UpButton_mouse_entered():
	if controllerapeared:
		inreact = true
		print("caca lista")


func _on_WeaponIcon_mouse_entered():
	if controllerapeared:
		inreact = true
		print("caca lista")


func _on_DownButton_mouse_entered():
	if controllerapeared:
		inreact = true
		print("caca lista")
