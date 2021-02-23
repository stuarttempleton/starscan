extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var poi_types = ["Artifact","Resource","Hazard", "Empty", "Exhausted", "Unknown"]
var poi_node = ""
var type = "Empty"
var exhausted = false
var defaultScale
var bigScale = Vector2(0.35,0.35)
var ScaleToVector = Vector2(0,0)
var lerpSpeed = 10

func _ready():
	$ClickArea.connect("selected", self, "selected")
	$ClickArea.connect("hover", self, "hover")
	$ClickArea.connect("unhover", self, "unhover")

func hover(hover_position):
	ScaleToVector = bigScale
	get_parent().get_parent().get_parent().get_parent().POIHover(hover_position)
	pass


func unhover():
	ScaleToVector = defaultScale
	get_parent().get_parent().get_parent().get_parent().POIUnhover()
	pass


func selected():
	if !exhausted:
		exhausted = true
		get_parent().get_parent().get_parent().get_parent().POISelect(type)
		CollectPOI(type)
		GameNarrativeDisplay.connect("ChoiceSelected", self, "StoryResponse")
		GameNarrativeDisplay.DisplayText(StoryGenerator.POIStory(type),["OK"])
	pass

func CollectPOI(POIType):
	print(ShipData.StarShip.Inventory)
	match POIType:
		"Artifact":
			print("collecting artifact")
			ShipData.GainInventoryItem("Artifacts", 1)
			#remove from planet
		"Resource":
			print("collecting resource")
			ShipData.GainInventoryItem("Resources", 1)
			#remove from planet
		"Hazard":
			print("TO DO handling hazard")
			#apply effect
			#do we remove?
	print(ShipData.StarShip.Inventory)

func StoryResponse(choice):
	GameNarrativeDisplay.disconnect("ChoiceSelected", self, "StoryResponse")
	SetPOIInfo("Exhausted")
	pass


func _process(delta):
	if poi_node.scale.distance_to(ScaleToVector) <= 0.01:
		poi_node.scale = ScaleToVector
	else:
		poi_node.scale = poi_node.scale.linear_interpolate(ScaleToVector, lerpSpeed * delta)


func SetPOIInfo(poi_type):
	for _p in poi_types:
		get_node(_p).visible = false
	poi_node = get_node(poi_type)
	poi_node.visible = true
	type = poi_type
	
	defaultScale = poi_node.scale
	ScaleToVector = defaultScale
