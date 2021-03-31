extends Node2D

const TotalPOIsPerPlanet = 10

export var POITemplates = {
	"Artifact":"PATH",
	"Resource":"PATH",
	"Hazard":"PATH"
}
export var poi_template_path = "res://planet_maps/POI.tscn"

var Planet
var Scan
var poi_nodes = []

func _ready():
	Cheat.connect("cheat_resetpois", self, "_reset")
	Cheat.connect("cheat_setscan", self, "_reset")

func _reset():
	print("Resetting POIs")
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
	print("POI nodes cleared")
	pass

func _generatePOIData(rng):
	Planet.POIs = []
	_generatePOIsOfType("Artifact", Planet.ArtifactCount, rng)
	_generatePOIsOfType("Resource", Planet.ResourceCount, rng)
	_generatePOIsOfType("Hazard", Planet.HazardCount, rng)
	var emptyCount = TotalPOIsPerPlanet - Planet.ArtifactCount - Planet.ResourceCount - Planet.HazardCount
	_generatePOIsOfType("Empty", emptyCount, rng)
	
func _generatePOIsOfType(poiType, count, rng):
	for i in count:
		var poiPos = Vector2(rng.randf_range(0, 1), rng.randf_range(0, 1))
		var poiData = Dictionary()
		poiData.X = poiPos.x
		poiData.Y = poiPos.y
		poiData.ActualType = poiType
		poiData.PerceivedType = "Unknown"
		poiData.IsExhausted = false
		poiData.ScanDifficulty = rng.randf_range(0, 1)
		Planet.POIs.append(poiData)
	
func _applyScanToPOIs():
	for poi in Planet.POIs:
		if Scan >= poi.ScanDifficulty:
			poi.PerceivedType = poi.ActualType if !poi.IsExhausted else "Exhausted"
		else:
			poi.PerceivedType = "Unknown"
	
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
	var poi = loaded_scene.instance()
	add_child(poi)
	poi_nodes.append(poi)
	
	poi.position = poiScreenPos
	poi.POIModel = poiData

func _convertToScreenPos(normalizedPos, maxPos, offset):	
	return Vector2(normalizedPos.x * maxPos.x + offset.x, normalizedPos.y * maxPos.y + offset.y)
