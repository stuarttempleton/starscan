extends Node2D


var MapScale = StarMapData.MapScale
var PlanetSizeScale = 5
export var NebulaPath = ""

func _ready():
	GameController.EnterGameLoop(true)
	print("Nebulae found: ", len(StarMapData.Nebulae()) )
	
	
	for nebula in StarMapData.Nebulae():
		print("Building nebula: ", nebula.Name)
		AddNebulaToMap(Vector2(nebula.X * MapScale, nebula.Y * MapScale), get_nebula_scale(nebula.Size))
		pass

func get_nebula_scale(size_str):
	var nebula_size = 5
	if (size_str == "Medium"):
		nebula_size = 3
	elif (size_str == "Tiny"):
		nebula_size = 1
	return nebula_size
	
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
	draw_circle(Vector2(system.X * MapScale, system.Y * MapScale), system.Planets.size() * PlanetSizeScale ,Color(1.12, 1.12, 0.6))
	pass

