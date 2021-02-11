extends Node2D


var allow_planet_click = false # this is a toggle for what you're viewing.

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
		$CanvasLayer/PlanetSurface._generate_planet_map($SystemView/SolarSystem.system.Planets[_planetID])
		$CanvasLayer/SystemViewUI/ActionButtons/LeaveOrbit.visible = true
		$CanvasLayer/SystemViewUI/ActionButtons/LeaveSystem.visible = false


func ViewSystem():
	if(!allow_planet_click):
		ToggleView()
		$CanvasLayer/SystemViewUI/ActionButtons/LeaveOrbit.visible = false
		$CanvasLayer/SystemViewUI/ActionButtons/LeaveSystem.visible = true


func ToggleView():
	allow_planet_click = !allow_planet_click
	$CanvasLayer/PlanetSurface.visible = !allow_planet_click
	$CanvasLayer/SystemViewUI/ActionButtons/LeaveOrbit.visible = !allow_planet_click
	$CanvasLayer/SystemViewUI/ActionButtons/LeaveSystem.visible = allow_planet_click

func POIHover(_point):
	print("POIHover()")

func POIUnhover():
	print("POIUnhover()")

func POISelect():
	print("POISelect()")

