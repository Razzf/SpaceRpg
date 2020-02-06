extends HBoxContainer

onready var ShieldLabel = $ShieldLabel
onready var EnergyLabel = $EnergyLabel
onready var ApLabel = $ApLabel

func _ready():
	pass # Replace with function body.



func _on_ShipStats_Ap_Changed(value):
	var stringAp = str(value)
	ApLabel.text = stringAp + "Ap"
	


func _on_ShipStats_Energy_Changed(value):
	var stringEnergy = str(value)
	EnergyLabel.text = stringEnergy + "Ep"


func _on_ShipStats_Shield_Changed(value):
	var stringShield = str(value)
	ShieldLabel.text = stringShield + "Ep"
