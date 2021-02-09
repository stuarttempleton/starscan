extends Node2D


export var POITemplates = {
	"Artifact":"PATH",
	"Resource":"PATH",
	"Hazard":"PATH"
}
export var poi_template_path = ""

func _generate(planet):
	var points = _generatePoints(10, planet.SurfaceSeednumber)
	points.shuffle()
	print(planet)
	var i = 0
	
	for point in planet.ArtifactCount:
		print("Artifact: ", points[i])
		#AddPOIToMap(points[point],"Artifact")
		i += 1
	for point in planet.ResourceCount:
		print("Resource: ", points[i])
		#AddPOIToMap(points[point],"Resource")
		i += 1
	for point in planet.HazardCount:
		print("Hazard: ", points[i])
		#AddPOIToMap(points[point],"Hazard")
		i += 1
	for point in range(i, points.size()):
		print("Empty: ", points[i])
		#AddPOIToMap(points[point],"Hazard") 
		i += 1
	pass


func _generatePoints(Quantity, seedNumber):
	var points = []
	var x = get_viewport().get_visible_rect().size.x
	var y = get_viewport().get_visible_rect().size.y
	
	var rng = RandomNumberGenerator.new()
	rng.seed = seedNumber
	
	for p in Quantity:
		points.append(Vector2(x * rng.randf_range(0, 1), y * rng.randf_range(0, 1)))
	return points


func AddPOIToMap( _position, _type ) :
	var loaded_scene = load(poi_template_path)
	var poi = loaded_scene.instance()
	add_child(poi)
	
	poi.position = _position

