extends Node2D


export var Planets = {}
var Planet
var PlanetID = 0

func get_planet_scale(size_str):
	var planet_size = 1
	if (size_str == "Medium"):
		planet_size = 0.66
	elif (size_str == "Tiny"):
		planet_size = 0.33
	return planet_size
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$ClickArea.connect("planet_selected", self, "planet_selected")

func planet_selected():
	if (PlanetID >= 0):
	 print("Selected: %s" % [PlanetID])
	
func SetPlanetInfo(planet_type, planet_scale, planet_id):
	for _p in Planets.values():
		get_node(_p).visible = false
	Planet = get_node(Planets[planet_type])
	Planet.visible = true
	Planet.scale *= Vector2(Planet.scale.x * get_planet_scale(planet_scale), Planet.scale.y * get_planet_scale(planet_scale)) 
	PlanetID = planet_id

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
