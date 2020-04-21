extends Particles2D


func _ready():
	print(self.process_material)
	yield(get_tree().create_timer(6), "timeout")
	self.process_material.emission_box_extents = Vector3(9,16,1)
	self.process_material.radial_accel = 100
	
	
