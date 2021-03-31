extends Node


var StarMap
var MapScale = 10000
var Loaded = false
var SavedSinceLoad = false
export var DatabaseFileName = "res://starmap_data/generated/Generated_2021-3-31_6-32-20_6527443740791628228.json"
export var SavedDatabaseFileName = "user://testdata_PLAYERSAVE.json"

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
	self.LoadMapData(DatabaseFileName)
	
	#EXPLANATION
	
	#Print name of first planet in first system
	#print(self.Systems()[0].Planets[0].Name)
	#print(self.Systems()[0].X - self.Systems()[0].Y)
	
	#Change name of first planet in first system
	#self.Systems()[0].Planets[0].Name = "updated name!"
	
	#Save to a save file
	#self.Save(SavedDatabaseFileName)

func ResetMap() :
	self.LoadMapData(DatabaseFileName)
	var dir = Directory.new()
	dir.remove(SavedDatabaseFileName)
	self.SaveMap()

func LoadSave() :
	if (!self.SaveExists()):
		self.LoadMapData(DatabaseFileName)
		self.SaveMap()
	self.LoadMapData(SavedDatabaseFileName)

func SaveMap() :
	self.Save(SavedDatabaseFileName)
	
func SaveExists():
	var save_file = File.new()
	return save_file.file_exists(SavedDatabaseFileName)
	
func LoadMapData(filename):
	print("Loading map data from %s" % filename)
	var starmapdata_file = File.new()
	starmapdata_file.open(filename, File.READ)
	var starmapdata_json = JSON.parse(starmapdata_file.get_as_text())
	starmapdata_file.close()
	StarMap = starmapdata_json.result
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
		
func SystemHasOutpost(system):
	for planet in system.Planets:
		if PlanetTypes[8] == planet.Type:
			return true
	return false
	
func GetNearestOutpostSystem(origin):
	var NearestOutpostSystem = StarMap.Systems[0]
	var previous_distance = origin.distance_to(Vector2(StarMap.Systems[0].X, StarMap.Systems[0].Y))
	
	for system in StarMap.Systems :
		if not SystemHasOutpost(system): continue
		var distance = origin.distance_to(Vector2(system.X, system.Y))
		if (distance < previous_distance):
			previous_distance = distance
			NearestOutpostSystem = system
			
	return NearestOutpostSystem

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
	#print("Shuffled icons for " + planet.Name + ": " + str(icons))
	
	planet.PerceivedArtifactCount = 0
	planet.PerceivedResourceCount = 0
	planet.PerceivedHazardCount = 0
	planet.PerceivedDudCount = 0
	
	var scanCount = totalIcons * quality
	#print("\tRevealing " + str(scanCount) + " icons.")
	for i in range(scanCount):
		if icons[i] == "Artifact":
			planet.PerceivedArtifactCount += 1
		if icons[i] == "Resource":
			planet.PerceivedResourceCount += 1
		if icons[i] == "Hazard":
			planet.PerceivedHazardCount += 1
		if icons[i] == "Dud":
			planet.PerceivedDudCount += 1
