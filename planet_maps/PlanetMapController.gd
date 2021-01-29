extends Node2D



func _ready():
	pass


func _generate_planet_map(planet):
	$PlanetMap.visible = true
	$PlanetMap._generate(planet)


func _on_LeaveOrbitButton_pressed():
	get_parent().ViewSystem()

func _on_generate_button_pressed(planet_type):
	$PlanetMap._generate(StarMapData.GetRandomPlanetByType(planet_type))
