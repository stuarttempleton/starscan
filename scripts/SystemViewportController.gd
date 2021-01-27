extends Node2D


var allow_planet_click = false


func _ready():
	ToggleView()
	pass # Replace with function body.

func PlanetHover(planet_position, planet_name):
	$HoverUI/Label.text = planet_name
	$HoverUI.set_position(Vector2(planet_position.x - $HoverUI.get_rect().size.x/2, planet_position.y - $HoverUI.get_rect().size.x/2))
	$HoverUI.visible = true
	pass
	
func PlanetUnhover():
	$HoverUI.visible = false
	pass
	
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

