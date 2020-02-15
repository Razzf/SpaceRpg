extends HBoxContainer

onready var ShieldLabel = $ShieldLabelPanel/ShieldLabel
onready var EnergyLabel = $EnergyLabelPanel/EnergyLabel

func _ready():
	pass # Replace with function body.

func _on_SpaceShip_Energy_Changed(value):
	var stringEnergy = str(value)
	EnergyLabel.text = stringEnergy + "Ep"

func _on_SpaceShip_Shield_Changed(value):
	var stringShield = str(value)
	ShieldLabel.text = stringShield + "Sp"
