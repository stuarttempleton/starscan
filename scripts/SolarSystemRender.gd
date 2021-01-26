extends Node2D

export var planet_scene_path = ""
var system

var orbit_color = Color(0.2, 0.2, 0.2)
var built = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if (StarMapData.NearestSystem == null):
		StarMapData.FindNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y))
	system = StarMapData.NearestSystem
	
func _draw():
	if(!built):
		BuildSystem()
		built = true

func BuildSystem():
	var center = Vector2(get_viewport().get_visible_rect().size.x/2, get_viewport().get_visible_rect().size.y/2)
	var system_size = system.Planets.size()
	print("building system: %s (%d)" % [system.Name, system_size])
	
	#build star
	AddPlanetToMap(center, "Giant", "Star", -1)
	
	var radius_offset = 50
	var orbital_radius = 50 #start here
	
	#Build orbits and planets
	var i = 0
	for planet in system.Planets:
		print(planet.Type)
		var next_planet_center = draw_circle_arc(center, orbital_radius, 0, 360, orbit_color )
		randomize()
		orbital_radius += rand_range(25, radius_offset)
		AddPlanetToMap(next_planet_center, planet.Size, planet.Type, i)
		i += 1

func AddPlanetToMap( planet_position, planet_size, planet_type, planet_id ) :
	var loaded_scene = load(planet_scene_path)
	var planet = loaded_scene.instance()
	add_child(planet)
	
	#set position, sprite, and scale
	planet.position = planet_position
	planet.SetPlanetInfo(planet_type, planet_size, planet_id)

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
