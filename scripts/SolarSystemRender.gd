extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var system_id = 2
var system

var orbit_color = Color(0.2, 0.2, 0.2)
var star_color = Color(1.12, 1.12, 0.9)

var gas_planet = Color(0.902344, 0.73186, 0.370102)
var ice_planet = Color(0.40625, 0.986084, 1)
var lava_planet = Color(1, 0.117188, 0)
var goldilocks_planet = Color(0.332031, 1, 0.608612)
var desert_planet = Color(1, 0.988342, 0.253906)
var ocean_planet = Color(0, 0.25, 1)
var asteroid_planet = Color(1.12, 1.12, 0.9)
var comet_planet = Color(0, 0.742188, 1)
var outpost_planet = Color(0.320313, 0.320313, 0.320313)

var nebulae_color = Color(0.59668, 0, 0.8125)

# Called when the node enters the scene tree for the first time.
func _ready():
	if (StarMapData.NearestSystem == null):
		StarMapData.FindNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y))
	system = StarMapData.NearestSystem
	
func _draw():
	BuildSystem()

func get_planet_size(size_str):
	var planet_size = 5
	if (size_str == "Medium"):
		planet_size *= 2
	elif (size_str == "Giant"):
		planet_size *= 3
	return planet_size	


func get_planet_color(planet_type):
	if (planet_type == "Gas"):
		return gas_planet
	elif (planet_type == "Ice"):
		return ice_planet
	elif (planet_type == "Lava"):
		return lava_planet
	elif (planet_type == "Goldilocks"):
		return goldilocks_planet
	elif (planet_type == "Desert"):
		return desert_planet
	elif (planet_type == "Ocean"):
		return ocean_planet
	elif (planet_type == "Asteroid Belt"):
		return asteroid_planet
	elif (planet_type == "Comet"):
		return comet_planet
	elif (planet_type == "Outpost"):
		return outpost_planet
	
func BuildSystem():
	
	var center = Vector2(get_viewport().get_visible_rect().size.x/2, get_viewport().get_visible_rect().size.y/2)
	var system_size = system.Planets.size()
	print("building system: %s (%d)" % [system.Name, system_size])
	
	#build star
	AddPlanetToMap(center, 20, star_color)
	
	var radius_offset = 50
	var orbital_radius = 50 #start here
	
	#Build orbits and planets
	for planet in system.Planets:
		print(planet.Type)
		var next_planet_center = draw_circle_arc(center, orbital_radius, 0, 360, orbit_color )
		randomize()
		orbital_radius += rand_range(25, radius_offset)
		AddPlanetToMap( next_planet_center, get_planet_size(planet.Size), get_planet_color(planet.Type))

	
func AddPlanetToMap( planet_position, planet_size, planet_color ) :
	draw_circle(planet_position, planet_size ,planet_color)
	pass
	
func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 64
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)
		
	randomize()
	return points_arc[rand_range(0,nb_points - 1)]
