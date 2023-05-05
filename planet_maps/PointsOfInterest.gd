extends Node2D

const TotalPOIsPerPlanet = 10

@export var POITemplates = {
	"Artifact":"PATH",
	"Resource":"PATH",
	"Hazard":"PATH"
}
@export var poi_template_path = "res://planet_maps/POI.tscn"

var Planet
var Scan
var poi_nodes = []

func _ready():
	# warning-ignore:return_value_discarded
	Cheat.connect("cheat_resetpois",Callable(self,"_reset"))
	# warning-ignore:return_value_discarded
	Cheat.connect("cheat_setscan",Callable(self,"_reset"))

func _reset():
	_generate(Planet, Scan)

func _generate(planet, scan):
	Planet = planet
	Scan = scan
	var rng = RandomNumberGenerator.new()
	rng.seed = Planet.SurfaceSeednumber
	
	ClearPOINodes()
	if !Planet.has("POIs") || Planet.POIs == null:
		_generatePOIData(rng)
	_applyScanToPOIs()
	_addPOINodes()

func ClearPOINodes():
	for poi in poi_nodes:
		poi.queue_free()
	poi_nodes.clear()
	pass

var poi_scan_difficulties = []
func _generatePOIData(rng):
	Planet.POIs = []
	poi_scan_difficulties = []
	_generatePOIsOfType("Artifact", Planet.ArtifactCount, rng)
	_generatePOIsOfType("Resource", Planet.ResourceCount, rng)
	_generatePOIsOfType("Hazard", Planet.HazardCount, rng)
	var emptyCount = TotalPOIsPerPlanet - Planet.ArtifactCount - Planet.ResourceCount - Planet.HazardCount
	_generatePOIsOfType("Empty", emptyCount, rng)
	_calculateScanInterference()
	
func _calculateScanInterference():
	var scan_average = 0
	var poi_scan_hardest = 0
	for scan in poi_scan_difficulties:
		if scan > poi_scan_hardest: 
			poi_scan_hardest = scan
		scan_average += scan
	scan_average = scan_average / poi_scan_difficulties.size()
	if poi_scan_hardest > Scan:
		$"../PlanetSurfaceMap/PlanetInformation".text += "\r\nScan Interference: %.0d%%" % [ poi_scan_hardest * 100]

func _generatePOIsOfType(poiType, count, rng):
	for i in count:
		var poiPos = Vector2(rng.randf_range(0, 1), rng.randf_range(0, 1))
		var poiData = Dictionary()
		poiData.X = poiPos.x
		poiData.Y = poiPos.y
		poiData.ActualType = poiType
		poiData.PerceivedType = "Unknown"
		poiData.IsExhausted = false
		poiData.ScanDifficulty = rng.randf_range(0, 0.5) + rng.randf_range(0, 0.3) + 0.1
		Planet.POIs.append(poiData)
		poi_scan_difficulties.append(poiData.ScanDifficulty)
	
func _applyScanToPOIs():
	for poi in Planet.POIs:
		if Scan >= poi.ScanDifficulty:
			poi.PerceivedType = poi.ActualType if !poi.IsExhausted else "Exhausted"
		else:
			poi.PerceivedType = "Unknown" if !poi.IsExhausted else "Exhausted"
	
func _addPOINodes():
	var margin = 0.75
	var maxPos = get_viewport().get_visible_rect().size
	var offset = maxPos * ((1 - margin) / 2)
	maxPos *= margin
	
	for poiData in Planet.POIs:
		var poiScreenPos = _convertToScreenPos(Vector2(poiData.X, poiData.Y), maxPos, offset)
		_addPOINode(poiScreenPos, poiData)

func _addPOINode( poiScreenPos, poiData ) :
	var loaded_scene = load(poi_template_path)
	var poi = loaded_scene.instantiate()
	add_child(poi)
	poi_nodes.append(poi)
	
	poi.position = poiScreenPos
	poi.POIModel = poiData

func _convertToScreenPos(normalizedPos, maxPos, offset):	
	return Vector2(normalizedPos.x * maxPos.x + offset.x, normalizedPos.y * maxPos.y + offset.y)
