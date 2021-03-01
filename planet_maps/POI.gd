extends Node2D


var poi_types = ["Artifact","Resource","Hazard", "Empty", "Exhausted", "Unknown"]
var poi_node = ""
var type = "Empty"
var preceived_type = "Empty"
var exhausted = false
var defaultScale
var bigScale = Vector2(0.35,0.35)
var ScaleToVector = Vector2(0,0)
var lerpSpeed = 10


func _ready():
	$Hover.hide()
	$ClickArea.connect("selected", self, "selected")
	$ClickArea.connect("hover", self, "hover")
	$ClickArea.connect("unhover", self, "unhover")


func hover(hover_position):
	ScaleToVector = bigScale
	$Hover.show()
	get_parent().get_parent().get_parent().get_parent().POIHover(hover_position)
	pass


func unhover():
	ScaleToVector = defaultScale
	$Hover.hide()
	get_parent().get_parent().get_parent().get_parent().POIUnhover()
	pass


func selected():
	if !exhausted:
		exhausted = true
		var qty = 1 #TODO: Adjust this for "severity"
		get_parent().get_parent().get_parent().get_parent().POISelect(type)
		CollectPOI(type, qty)
		GameNarrativeDisplay.connect("ChoiceSelected", self, "StoryResponse")
		GameNarrativeDisplay.DisplayText(StoryGenerator.POIStory(type, qty),["OK"])
	pass

func CollectPOI(POIType, qty):
	match POIType:
		"Artifact":
			ShipData.GainInventoryItem("Artifacts", qty)
			get_parent().Planet.ArtifactCount = max(get_parent().Planet.ArtifactCount - qty, 0)
		"Resource":
			ShipData.GainInventoryItem("Resources", qty)
			get_parent().Planet.ResourceCount = max(get_parent().Planet.ResourceCount - qty, 0)
		"Hazard":
			ShipData.DeductCrew(qty)

func StoryResponse(choice):
	GameNarrativeDisplay.disconnect("ChoiceSelected", self, "StoryResponse")
	SetPOIInfo("Exhausted", "Exhausted")
	pass


func _process(delta):
	if poi_node.scale.distance_to(ScaleToVector) <= 0.01:
		poi_node.scale = ScaleToVector
	else:
		poi_node.scale = poi_node.scale.linear_interpolate(ScaleToVector, lerpSpeed * delta)


func SetPOIInfo(poi_type, perceived):
	for _p in poi_types:
		get_node(_p).visible = false
	poi_node = get_node(perceived)
	poi_node.visible = true
	type = poi_type
	preceived_type = perceived
	
	defaultScale = poi_node.scale
	ScaleToVector = defaultScale
	$Hover.text = preceived_type
