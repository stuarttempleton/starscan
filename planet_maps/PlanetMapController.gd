extends Node2D



func _ready():
	_generate_planet_map("Goldilocks")
	pass


func _generate_planet_map(planet_type):
	$PlanetMap.visible = true
	$PlanetMap._generate(planet_type)


func _on_LeaveOrbitButton_pressed():
	get_parent().ViewSystem()


func _on_generate_button_pressed(planet_type):
	$PlanetMap._generate(planet_type)
