extends Node2D


export var Planets = {}
var Planet
var PlanetID = 0
var PlanetName = ""


func get_planet_scale(size_str):
	var planet_size = 1
	if (size_str == "Medium"):
		planet_size = 0.66
	elif (size_str == "Tiny"):
		planet_size = 0.33
	return planet_size


func _ready():
	$ClickArea.connect("planet_selected", self, "planet_selected")
	$ClickArea.connect("planet_hover", self, "planet_hover")
	$ClickArea.connect("planet_unhover", self, "planet_unhover")

func planet_hover(planet_position, planet_name):
	get_parent().get_parent().get_parent().PlanetHover(planet_position, planet_name)
	pass
	
	
func planet_unhover():
	get_parent().get_parent().get_parent().PlanetUnhover()
	pass
	
	
func planet_selected():
	if (PlanetID >= 0):
		get_parent().get_parent().get_parent().ViewPlanet(PlanetID)


func SetPlanetInfo(planet_type, planet_scale, planet_id, planet_name):
	for _p in Planets.values():
		get_node(_p).visible = false
	Planet = get_node(Planets[planet_type])
	Planet.visible = true
	Planet.scale *= Vector2(Planet.scale.x * get_planet_scale(planet_scale), Planet.scale.y * get_planet_scale(planet_scale)) 
	PlanetID = planet_id
	PlanetName = planet_name

