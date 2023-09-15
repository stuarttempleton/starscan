extends Node2D


var MapScale = StarMapData.MapScale
var PlanetSizeScale = 5
var camera
var avatar
var cached_zoom = Vector2.ZERO
export var NebulaPath = ""
export var WormholePath = ""

func _ready():
	GameController.EnterGameLoop(true)
	for nebula in StarMapData.Nebulae():
		AddNebulaToMap(Vector2(nebula.X * MapScale, nebula.Y * MapScale), StarMapData.get_nebula_scale(nebula.Size) * (MapScale / 10000))
		AddWormholeToMap(Vector2(nebula.X * MapScale, nebula.Y * MapScale))
	# warning-ignore:return_value_discarded
	camera = $"../ShipAvatarView/ShipAvatar/Camera2D"
	avatar = $"../ShipAvatarView/ShipAvatar"
	GameController.connect("map_state", self, "MapToggle")

func _process(delta):
	if avatar.CurrentSpeed > 0:
		update()
	if cached_zoom != camera.zoom:
		cached_zoom = camera.zoom
		update()

func AddWormholeToMap(pos):
	var loaded_scene = load(WormholePath)
	var wormhole = loaded_scene.instance()
	add_child(wormhole)
	
	wormhole.position = pos

func AddNebulaToMap(pos,size):
	var loaded_scene = load(NebulaPath)
	var nebula = loaded_scene.instance()
	add_child(nebula)
	
	nebula.position = pos
	nebula.scale *= Vector2(nebula.scale.x * size, nebula.scale.y * size)
	
func _draw():
	var ShipPosition = ShipData.GetPosition()
	var ScreenRect = get_viewport_rect()
	ScreenRect.size = ScreenRect.size * camera.zoom * 1.5
	ScreenRect.position = ShipPosition - ScreenRect.size * 0.5
	
	var systems = StarMapData.AllSystemsInRect(ScreenRect)
	
	for system in systems :
		AddSystemToMap(system)

func AddSystemToMap( system ) :
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

func MapToggle(usemap):
	update()
