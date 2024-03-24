extends Node2D


export var Planets = {}
var Planet
var PlanetID = 0
var PlanetName = ""
var defaultScale
var bigScale = Vector2(0.35,0.35)
var ScaleToVector = Vector2(0,0)
var lerpSpeed = 10

func get_planet_scale(size_str):
	var planet_size = 1
	if (size_str == "Medium"):
		planet_size = 0.66
	elif (size_str == "Tiny"):
		planet_size = 0.33
	return planet_size


func _ready():
	# warning-ignore:return_value_discarded
	$ClickArea.connect("planet_selected", self, "planet_selected")
	# warning-ignore:return_value_discarded
	$ClickArea.connect("planet_hover", self, "planet_hover")
	# warning-ignore:return_value_discarded
	$ClickArea.connect("planet_unhover", self, "planet_unhover")

func planet_hover(planet_position, planet_name):
	ScaleToVector = bigScale
	get_parent().get_parent().get_parent().PlanetHover(planet_position, planet_name)
	pass
	
	
func planet_unhover():
	ScaleToVector = defaultScale
	get_parent().get_parent().get_parent().PlanetUnhover()
	pass
	
	
func planet_selected():
	if (PlanetID >= 0):
		get_parent().get_parent().get_parent().ViewPlanet(PlanetID)

# Respond to button/control focus stuff for gamepad input
func grab_focus():
	planet_hover(position, PlanetName)

func release_focus():
	planet_unhover()

func select():
	planet_selected()


func _process(delta):
	if Planet.scale.distance_to(ScaleToVector) <= 0.01:
		Planet.scale = ScaleToVector
	else:
		Planet.scale = Planet.scale.linear_interpolate(ScaleToVector, lerpSpeed * delta)


func SetPlanetInfo(planet_type, planet_scale, planet_id, planet_name):
	for _p in Planets.values():
		get_node(_p).visible = false
	Planet = get_node(Planets[planet_type])
	Planet.visible = true
	Planet.scale *= Vector2(Planet.scale.x * get_planet_scale(planet_scale), Planet.scale.y * get_planet_scale(planet_scale)) 
	PlanetID = planet_id
	PlanetName = planet_name
	
	defaultScale = Planet.scale
	ScaleToVector = defaultScale
	bigScale = Vector2(Planet.scale.x + 0.2, Planet.scale.y + 0.2) 
	

