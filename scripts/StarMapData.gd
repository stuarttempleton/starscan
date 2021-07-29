extends Node


var StarMap
var MapScale = 30000
var Loaded = false
var SavedSinceLoad = false
export var DefaultUniverseFile = "res://starmap_data/generated/Generated_2021-3-31_6-32-20_6527443740791628228.json"
export var SavedUniverseFile = "user://Player_Universe_Data.json"

var NearestSystem = null
var NearestSystemDistance = INF
var NearestNebula = null
var NearestNebulaDistance = INF

var PlanetTypes = [
	"Gas",
	"Ice",
	"Lava",
	"Goldilocks",
	"Desert",
	"Ocean",
	"Asteroid Belt",
	"Comet",
	"Outpost"
]

var PlanetSizes = [
	"Giant",
	"Medium",
	"Tiny"
]

func _ready():
	self.LoadMapData(DefaultUniverseFile)

func GetMostRecentGeneratedFile():
	var files = []
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin(true, true)
	while true:
		var file = dir.get_next()
		if file == "":
			break
		if file.begins_with("Starmap_"):
			files.append(file)
	dir.list_dir_end()
	
	return "user://%s" % [files.back()] if not files.empty() else DefaultUniverseFile

func ResetMap() :
	self.LoadMapData(GetMostRecentGeneratedFile())
	var dir = Directory.new()
	dir.remove(SavedUniverseFile)
	self.SaveMap()

func LoadSave() :
	if (!self.SaveExists()):
		self.LoadMapData(GetMostRecentGeneratedFile())
		self.SaveMap()
	self.LoadMapData(SavedUniverseFile)

func SaveMap() :
	self.Save(SavedUniverseFile)
	
func SaveExists():
	var save_file = File.new()
	return save_file.file_exists(SavedUniverseFile)
	
func LoadMapData(filename):
	print("Loading map data from %s" % filename)
	var starmapdata_file = File.new()
	starmapdata_file.open(filename, File.READ)
	var starmapdata_json = JSON.parse(starmapdata_file.get_as_text())
	starmapdata_file.close()
	StarMap = starmapdata_json.result
	
	if !StarMap.has("MapSeed") || StarMap.MapSeed == null:
		StarMap.MapSeed = randi()
	if !StarMap.has("TravelRoutes") || StarMap.TravelRoutes == null:
		StarMap.TravelRoutes = []
	SetAllSystemOutpostFlags()
	SetSystemRoutes()
	SetOutpostRoutes()
	Loaded = true
	SavedSinceLoad = false
	
func Save(filename):
	var file = File.new()
	file.open(filename, File.WRITE)
	file.store_string(JSON.print(StarMap, "\t"))
	file.close()
	SavedSinceLoad = true;


func Nebulae() :
	if !Loaded :
		print("StarMap Not Loaded! FAILING ON PURPOSE FIX THIS")
	else:
		return StarMap.Nebulae
	
func Systems() :
	if !Loaded :
		print("StarMap Not Loaded! FAILING ON PURPOSE FIX THIS")
	else:
		return StarMap.Systems

func GetOutpost(system):
	for planet in system.Planets:
		if PlanetTypes[8] == planet.Type:
			return planet
	return false
func SystemHasPlanetWithArtifacts(system):
	for planet in system.Planets:
		if planet.ArtifactCount > 0 && "Outpost" != planet.Type:
			return true
	return false
func SystemHasPlanetWithResources(system):
	for planet in system.Planets:
		if planet.ResourceCount > 0 && "Outpost" != planet.Type:
			return true
	return false
func SystemHasPlanetWithHazards(system):
	for planet in system.Planets:
		if planet.HazardCount > 0 && "Outpost" != planet.Type:
			return true
	return false


func SetAllSystemOutpostFlags():
	for system in StarMap.Systems :
		for planet in system.Planets:
			if PlanetTypes[8] == planet.Type:
				SetMarkerForSystem(system, "HasOutpost")

func SetSystemRoutes():
	var system_list = AllOutpostSystemsByIndex()
	var qty = 10
	var rng
	rng = RandomNumberGenerator.new()
	rng.seed = StarMap.MapSeed
	var maxsystem = system_list.size() - 1
	for i in qty:
		var route = NewRoute(IncrementIfSame(system_list[rng.randi_range(0,maxsystem)], system_list[rng.randi_range(0,maxsystem)]))
		if !RouteListHas(StarMap.TravelRoutes, route):
			StarMap.TravelRoutes.append(route)

func SetOutpostRoutes():
	var system_list = AllOutpostSystemsByIndex()
	var qty = 2
	var rng
	rng = RandomNumberGenerator.new()
	rng.seed = StarMap.MapSeed
	
	var maxsystem = system_list.size() - 1
	for i in system_list:
		qty = 2 + StarMap.Systems[i].Planets.size() / 3
		for _route in qty:
			var route = NewRoute(IncrementIfSame(i, system_list[rng.randi_range(0,maxsystem)]))
			if !StarMap.Systems[i].has("TravelRoutes") || StarMap.Systems[i].TravelRoutes == null:
				StarMap.Systems[i].TravelRoutes = []
			if !RouteListHas(StarMap.Systems[i].TravelRoutes, route):
				StarMap.Systems[i].TravelRoutes.append(route)

func SystemPosition(system, use_mapscale = false):
	return Vector2(system.X, system.Y)
	
func DistanceBetween(system_a, system_b):
	return SystemPosition(system_a).distance_to(SystemPosition(system_b))

func AngleBetween(system_a, system_b):
	return rad2deg(SystemPosition(system_a).angle_to_point(SystemPosition(system_b)))

func NewRoute(ab):
	var route = {
		"A": ab[0],
		"B": ab[1],
		"Distance": DistanceBetween(StarMap.Systems[ab[0]], StarMap.Systems[ab[1]]),
		"Angle": AngleBetween(StarMap.Systems[ab[0]], StarMap.Systems[ab[1]])
	}
	return route

func RouteListHas(route_list, route):
	var has = false
	for rte in route_list:
		if rte.A == route.A and rte.B == route.B:
			has = true
		elif rte.A == route.B and rte.B == route.A:
			has = true
	return has

func IncrementIfSame(a, b):
	if a == b: b -= 1
	if b < 0: b = a + 1
	return [a,b]

func AllOutpostSystemsByIndex():
	var list = []
	var index = 0
	for system in StarMap.Systems:
		if SystemHasOutpost(system):
			list.append(index)
		index += 1
	return list

func AllRoutesByIndex(index):
	if StarMap.Systems[index].has("TravelRoutes"):
		return StarMap.Systems[index].TravelRoutes
	return []

func AllRoutesBySystem(system):
	var index = 0
	for sys in StarMap.Systems:
		if sys == system:
			return AllRoutesByIndex(index)
		index += 1
	return []

func AllRoutesBySystemList(systemList):
	var routes = []
	for sys in systemList:
		routes.append_array(AllRoutesBySystem(sys))
	return routes

func AllSystemsInRect(rect, systemList = StarMap.Systems, useMapScale = true):
	var scale = MapScale if useMapScale else 1
	var list = []
	for sys in systemList:
		if rect.has_point(SystemPosition(sys) * scale):
			list.append(sys) 
	return list

func AllSystemsInRadius(point, radius, systemList = StarMap.Systems, useMapScale = true):
	var scale = MapScale if useMapScale else 1
	var list = []
	for sys in systemList:
		if point.distance_to(SystemPosition(sys) * scale) <= radius:
			list.append(sys) 
	return list

func SystemHasOutpost(system):
	return SystemHasMarker(system, "HasOutpost")


func GetNearestOutpostSystem(origin):
	var NearestOutpostSystem
	var previous_distance = -1
	
	for system in StarMap.Systems :
		if SystemHasOutpost(system):
			var distance = origin.distance_to(Vector2(system.X, system.Y))
			if (distance < previous_distance or previous_distance < 0):
				previous_distance = distance
				NearestOutpostSystem = system
	return NearestOutpostSystem

func GetDistanceToSystem(origin, system):
	return origin.distance_to(Vector2(system.X, system.Y))

func getPlanetID(planet, system):
	var i = 0
	for p in system.Planets:
		if p.Name == planet.Name:
			return i
		i += 1
	return i

func GetPlanetsByType(planet_type):
	var planets = []
	
	for system in StarMapData.Systems():
		for planet in system.Planets:
			if (planet_type == planet.Type):
				planets.append(planet)
	return planets


func GetRandomPlanetByType(planet_type):
	var planets = GetPlanetsByType(planet_type)
	randomize()
	return planets[randi()%planets.size()]

func get_nebula_scale(size_str):
	var nebula_size = 5
	if (size_str == "Medium"):
		nebula_size = 3
	elif (size_str == "Tiny"):
		nebula_size = 1
	return nebula_size

func DistanceToNearestNebula(origin):
	var Nearbynebula = StarMap.Nebulae[0]
	var previous_distance = origin.distance_to(Vector2(StarMap.Nebulae[0].X, StarMap.Nebulae[0].Y))
	
	for nebula in StarMap.Nebulae :
		var distance = origin.distance_to(Vector2(nebula.X, nebula.Y))
		if (distance < previous_distance):
			previous_distance = distance
			Nearbynebula = nebula
			
	NearestNebula = Nearbynebula
	NearestNebulaDistance = previous_distance
	return NearestNebulaDistance
	
func FindNearestSystem(origin):
	var NearbySystem = StarMap.Systems[0]
	var previous_distance = origin.distance_to(Vector2(StarMap.Systems[0].X, StarMap.Systems[0].Y))
	
	for system in StarMap.Systems :
		var distance = origin.distance_to(Vector2(system.X, system.Y))
		if (distance < previous_distance):
			previous_distance = distance
			NearbySystem = system
			
	NearestSystem = NearbySystem
	NearestSystemDistance = previous_distance

func ScanNearestSystem(quality):
	var is_new_scan = (NearestSystem.Scan <= 0)
	NearestSystem.Scan = quality
	for planet in NearestSystem.Planets:
		ScanPlanet(planet, quality)
	return is_new_scan

func SystemHasMarker(SystemOrPlanet, Marker):
	if SystemOrPlanet.has(Marker):
		return SystemOrPlanet[Marker]
	return false

func SetMarkerForSystem(SystemOrPlanet, Marker):
	SystemOrPlanet[Marker] = true

func IsVisited(SystemOrPlanet):
	return SystemHasMarker(SystemOrPlanet, "Visited")

func SetVisited(SystemOrPlanet):
	SetMarkerForSystem(SystemOrPlanet,"Visited")

func AllPlanetsVisited(system):
	var visited = true
	for planet in system.Planets:
		if !IsVisited(planet):
			visited = false
	return visited


func ScanPlanet(planet, quality):
	var totalIcons = 10
	var icons = []
	icons.resize(totalIcons)
	for i in range(totalIcons):
		if i < planet.ArtifactCount:
			icons[i] = "Artifact"
		elif i < planet.ArtifactCount + planet.ResourceCount:
			icons[i] = "Resource"
		elif i < planet.ArtifactCount + planet.ResourceCount + planet.HazardCount:
			icons[i] = "Hazard"
		else:
			icons[i] = "Dud"
			
	#TODO: replace this shuffle, it doesn't use a configurable seed
	icons.shuffle()
	
	planet.PerceivedArtifactCount = 0
	planet.PerceivedResourceCount = 0
	planet.PerceivedHazardCount = 0
	planet.PerceivedDudCount = 0
	
	var scanCount = totalIcons * quality
	for i in range(scanCount):
		if icons[i] == "Artifact":
			planet.PerceivedArtifactCount += 1
		if icons[i] == "Resource":
			planet.PerceivedResourceCount += 1
		if icons[i] == "Hazard":
			planet.PerceivedHazardCount += 1
		if icons[i] == "Dud":
			planet.PerceivedDudCount += 1
