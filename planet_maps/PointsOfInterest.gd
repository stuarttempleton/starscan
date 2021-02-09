extends Node2D


export var POITemplates = {
	"Artifact":"PATH",
	"Resource":"PATH",
	"Hazard":"PATH"
}
export var poi_template_path = "res://planet_maps/POI.tscn"

var poi_list = []

func _generate(planet):
	ClearPOI()
	var points = _generatePoints(10, planet.SurfaceSeednumber)
	points.shuffle()
	print(planet)
	var i = 0
	
	for point in planet.ArtifactCount:
		#print("Artifact: ", points[i])
		AddPOIToMap(points[i],"Artifact")
		i += 1
	for point in planet.ResourceCount:
		#print("Resource: ", points[i])
		AddPOIToMap(points[i],"Resource")
		i += 1
	for point in planet.HazardCount:
		#print("Hazard: ", points[i])
		AddPOIToMap(points[i],"Hazard")
		i += 1
	for point in range(i, points.size()):
		#print("Empty: ", points[i])
		AddPOIToMap(points[i],"Empty") 
		i += 1
	pass

func ClearPOI():
	for poi in poi_list:
		remove_child(poi)
	poi_list.clear()
	pass


func _generatePoints(Quantity, seedNumber):
	var points = []
	var x = get_viewport().get_visible_rect().size.x
	var y = get_viewport().get_visible_rect().size.y
	var margin = 0.75
	var x_offset = (x * (1 - margin)) / 2
	var y_offset = (y * (1 - margin)) / 2
	x = x * margin 
	y = y * margin
	
	var rng = RandomNumberGenerator.new()
	rng.seed = seedNumber
	
	for p in Quantity:
		points.append(Vector2(x * rng.randf_range(0, 1) + x_offset, y * rng.randf_range(0, 1) + y_offset))
	return points


func AddPOIToMap( _position, _type ) :
	var loaded_scene = load(poi_template_path)
	var poi = loaded_scene.instance()
	add_child(poi)
	poi_list.append(poi)
	
	poi.position = _position
	poi.SetPOIInfo(_type)

