extends Node2D


var MapScale = StarMapData.MapScale
var PlanetSizeScale = 5
export var NebulaPath = ""

func _ready():
	GameController.EnterGameLoop(true)
	#print("Nebulae found: ", len(StarMapData.Nebulae()) )
	
	
	for nebula in StarMapData.Nebulae():
		AddNebulaToMap(Vector2(nebula.X * MapScale, nebula.Y * MapScale), StarMapData.get_nebula_scale(nebula.Size) * (MapScale / 10000))
		pass

	
func AddNebulaToMap(pos,size):
	var loaded_scene = load(NebulaPath)
	var nebula = loaded_scene.instance()
	add_child(nebula)
	
	#set position and scale
	nebula.position = pos
	nebula.scale *= Vector2(nebula.scale.x * size, nebula.scale.y * size)
	
func _draw():
	#draw space background
	#draw_rect( Rect2(Vector2(-5,-5), Vector2(MapScale + 10,MapScale + 10)), Color(0.289063, 0.289063, 0.289063) ) 
	#draw_rect( Rect2(Vector2(0,0), Vector2(MapScale,MapScale)), Color(0,0,0) )
	 
	var systems = StarMapData.Systems()
	for system in systems :
		AddSystemToMap(system)

func AddSystemToMap( system ) :
	#print("%s (%f, %f)" % [system.Name, system.X * MapScale, system.Y * MapScale]);
	if StarMapData.SystemHasOutpost(system):
		draw_circle_arc(Vector2(system.X * MapScale, system.Y * MapScale), system.Planets.size() * PlanetSizeScale * 9 , 0, 360, Color(1, 1, 1, 0.364706))
	
	draw_circle(Vector2(system.X * MapScale, system.Y * MapScale), system.Planets.size() * PlanetSizeScale ,Color(1.12, 1.12, 0.6))
	pass

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 64
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

