extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_planet_map("Goldilocks")
	pass

func _generate_planet_map(planet_type):
	for _i in self.get_children ():
		if (_i.name != "Control"):
			_i.visible = false
	get_node(planet_type).visible = true
	get_node(planet_type)._generate()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
