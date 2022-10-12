extends Node2D

var rng
var SeedNumber = -1
export var TravelRouteLabel = "res://TravelRoutes/TravelRouteLabel.tscn"
export var Enabled = true

var RouteLists = {
	"Sector": {
		"routes": [],
		"pool": [],
		"color": Color(0.662745, 0, 1, 0.67),
		"width": 10,
		"showText":true
	},
	"ShipMap":{
		"routes": [],
		"pool": [],
		"color": Color(1, 1, 1, 0.4),
		"width": 10,
		"showText":false
	},
	"Outpost":{
		"routes": [],
		"pool": [],
		"color": Color(1, 1, 1, 0.15),
		"width": 10,
		"showText":true
	}
}

var poll_rate = 0
var poll_timer = 0
var camera
var shipavatar

var _loadedLabelTemplate

func _ready():
	camera = $"../ShipAvatarView/ShipAvatar/Camera2D"
	shipavatar = $"../ShipAvatarView/ShipAvatar"
	_loadedLabelTemplate = load(TravelRouteLabel)
	
	if Enabled:
		GetRoutes()

func _process(delta):
	if !Enabled: return
	
	poll_timer += delta
	if poll_timer > poll_rate:
		poll_timer = 0
		UpdateRoutes()


func UpdateRoutes():
	GetRoutes()
	update()


func GrowPool(pool, number):
	var needed = number - pool.size()
	if needed > 0:
		for i in needed:
			var label = _loadedLabelTemplate.instance()
			$LabelPool.add_child(label)
			pool.append(label)
	elif needed < 0:
		for i in abs(needed):
			var item = pool.pop_back()
			item.queue_free()

func GetRoutes():
	var ShipPosition = ShipData.GetPosition()
	var ScreenRect = get_viewport_rect()
	ScreenRect.size = ScreenRect.size * camera.zoom
	ScreenRect.position = ShipPosition - ScreenRect.size * 0.5
	
	
	var visible_systems = StarMapData.AllSystemsInRect(ScreenRect)
	var nearby_systems = StarMapData.AllSystemsInRadius(ShipPosition, 300, visible_systems)
#
	RouteLists.Sector.routes = StarMapData.ScannedRoutes()
	var outpost_routes = StarMapData.AllRoutesBySystemList(nearby_systems)
	#if outpost_routes.size() > 0:
	RouteLists.Outpost.routes = outpost_routes 
	if ShipData.Ship().KnownRoutes.size() > 0:
		RouteLists.ShipMap.routes = ShipData.Ship().KnownRoutes
#		for rt in ShipData.Ship().KnownRoutes:
#			if !StarMapData.RouteListHas(RouteLists.Outpost.routes, rt):
#				RouteLists.ShipMap.routes.append(rt)
	UpdateLabels()



func UpdateLabels():
	for list in RouteLists:
		GrowPool(RouteLists[list].pool, RouteLists[list].routes.size())
		for i in RouteLists[list].pool.size():
			if i <= RouteLists[list].routes.size():
				if camera.zoom.x > 2:
					RouteLists[list].pool[i].get_node("LabelText").text = "%s <--> %s\r\n%.1f sector units" % [StarMapData.StarMap[RouteLists[list].routes[i].ObjectPool][RouteLists[list].routes[i].A].Name, StarMapData.StarMap[RouteLists[list].routes[i].ObjectPool][RouteLists[list].routes[i].B].Name, RouteLists[list].routes[i].Distance * StarMapData.MapScale]
				else:
					RouteLists[list].pool[i].get_node("LabelText").text = "%s <--> %s" % [StarMapData.StarMap[RouteLists[list].routes[i].ObjectPool][RouteLists[list].routes[i].A].Name, StarMapData.StarMap[RouteLists[list].routes[i].ObjectPool][RouteLists[list].routes[i].B].Name]
				if RouteLists[list].showText:
					RouteLists[list].pool[i].show()
				else:
					RouteLists[list].pool[i].hide()
			else:
				RouteLists[list].pool[i].hide()
			pass
		pass


func GetSubSegment(from, to, offset = 250):
	if camera.zoom.x > shipavatar.MaxCameraZoom:
		offset *= 5
	elif camera.zoom.x > 1:
		offset *= camera.zoom.x
	offset = min(offset, from.distance_to(to) * 0.5) #clamp
	return [from + from.direction_to(to) * offset, to + to.direction_to(from) * offset]


func _drawTravelRoutes(Routes):
	if !Enabled: return
	var ShipPosition = ShipData.GetPosition()
	
	for i in Routes.routes.size():
		var rte = Routes.routes[i - 1]
		var from = StarMapData.SystemPosition(StarMapData.StarMap[rte.ObjectPool][rte.A]) * StarMapData.MapScale
		var to = StarMapData.SystemPosition(StarMapData.StarMap[rte.ObjectPool][rte.B]) * StarMapData.MapScale
		draw_line(from,to,Routes.color,Routes.width,true)
		var segment = GetSubSegment(from, to)
		var label_point = Geometry.get_closest_point_to_segment_2d(ShipPosition, segment[0], segment[1])
		Routes.pool[i - 1].rect_position = get_viewport_transform().xform(label_point)
		#_labelPool[i - 1 + pool_offset].rect_scale = Vector2(1,1) / camera.zoom.clamped(2)
		#draw_circle(label_point,10, Color.red)
	pass

func _draw():
	for list in RouteLists:
		_drawTravelRoutes(RouteLists[list])
	
