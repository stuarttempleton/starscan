extends Node2D


var MapScale = StarMapData.MapScale
var PlanetSizeScale = 5


func _ready():
	pass # Replace with function body.

func _draw():
	#draw space background
	draw_rect( Rect2(Vector2(-5,-5), Vector2(MapScale + 10,MapScale + 10)), Color(0.289063, 0.289063, 0.289063) ) 
	draw_rect( Rect2(Vector2(0,0), Vector2(MapScale,MapScale)), Color(0,0,0) )
	 
	var systems = StarMapData.Systems()
	for system in systems :
		AddSystemToMap(system)

func AddSystemToMap( system ) :
	#print("%s (%f, %f)" % [system.Name, system.X * MapScale, system.Y * MapScale]);
	draw_circle(Vector2(system.X * MapScale, system.Y * MapScale), system.Planets.size() * PlanetSizeScale ,Color(255,255,255))
	pass

