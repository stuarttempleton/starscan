extends Node2D


var allow_planet_click = false


func _ready():
	ToggleView()
	pass # Replace with function body.


func ViewPlanet(_planetID):
	if (allow_planet_click):
		ToggleView()
		$PlanetView._generate_planet_map($SystemView/SolarSystem.system.Planets[_planetID])


func ViewSystem():
	if(!allow_planet_click):
		ToggleView()


func ToggleView():
	allow_planet_click = !allow_planet_click
	$PlanetView.visible = !allow_planet_click

