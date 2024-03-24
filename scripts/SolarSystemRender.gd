extends Node2D

export var planet_scene_path = ""
var system
var orbit_color = Color(0.2, 0.2, 0.2)
var build_menu_on_complete = false


func _ready():
	if (StarMapData.NearestSystem == null):
		StarMapData.FindNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y))
	system = StarMapData.NearestSystem
	if !StarMapData.IsVisited(system):
		StarMapData.SetVisited(system)
		ShipData.UpdatePlayStat("SystemsVisited",1)
	StarMapData.DistanceToNearestNebula(Vector2(system.X, system.Y))
	var nebuladistance = StarMapData.NearestNebulaDistance
	var nebula = StarMapData.NearestNebula
	var nebulascale = StarMapData.get_nebula_scale(nebula.Size)
	var max_neb_distance = 0.015
	
	if ( nebuladistance < max_neb_distance * nebulascale ):
		$"../Control/SystemAnomalyLabel".text = $"../Control/SystemAnomalyLabel".text % [nebula.Name]
		$"../../Nebula".visible = true
		var distance_scaling = 0.1 * nebulascale * 2
		$"../../Nebula".scale = Vector2($"../../Nebula".scale.x * distance_scaling, $"../../Nebula".scale.y * distance_scaling)
	else:
		$"../Control/SystemAnomalyLabel".text = ""
		$"../../Nebula/BGAudio".stop()
		$"../../Nebula".visible = false
	
	# warning-ignore:return_value_discarded
	get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")


func _on_viewport_size_changed():
	#this *can* fire twice (x and y)
	for child in get_children(): child.queue_free()
	update()


func _draw():
	BuildSystem()


func BuildSystem():
	var center = Vector2(get_viewport().get_visible_rect().size.x/2, get_viewport().get_visible_rect().size.y/2)
	var _system_size = system.Planets.size()
	
	#build star
	AddPlanetToMap(center, "Giant", "Star", -1, system.Name)
	
	var orbital_radius = 50
	
	#Build orbits and planets
	var i = 0
	for planet in system.Planets:
		var rng = RandomNumberGenerator.new()
		rng.seed = planet.SurfaceSeednumber
		
		var next_planet_center = draw_circle_arc(center, orbital_radius, 0, 360, orbit_color, rng )
		orbital_radius += planet.RadialOffset
		AddPlanetToMap(next_planet_center, planet.Size, planet.Type, i, planet.Name)
		i += 1
	if build_menu_on_complete:
		EnableMenu()

func EnableMenu():
	#System is not ready
	if (get_children().size() < system.Planets.size() + 1): # include the sun
		build_menu_on_complete = true
		return
	GamepadMenu.add_menu( name ,get_children())
	
func AddPlanetToMap( planet_position, planet_size, planet_type, planet_id, planet_name ) :
	var loaded_scene = load(planet_scene_path)
	var planet = loaded_scene.instance()
	add_child(planet)
	
	#set position, sprite, and scale
	planet.position = planet_position
	planet.SetPlanetInfo(planet_type, planet_size, planet_id, planet_name)


func draw_circle_arc(center, radius, angle_from, angle_to, color, rng):
	var nb_points = 64
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)
	
	return points_arc[rng.randi_range(0,nb_points - 1)]
