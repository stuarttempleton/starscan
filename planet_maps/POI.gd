extends Node2D

const poi_types = ["Artifact","Resource","Hazard", "Empty", "Exhausted", "Unknown"]

var POIModel setget set_POIModel, get_POIModel
var poi_node = ""
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
	if !POIModel.IsExhausted:
		POIModel.IsExhausted = true
		var qty = 1 #TODO: Adjust this for "severity"
		get_parent().get_parent().get_parent().get_parent().POISelect(POIModel.ActualType)
		CollectPOI(POIModel.ActualType, qty)
		AudioPlayer.PlaySFX(GetAudioKeyForPOI(POIModel.ActualType))
		GameNarrativeDisplay.connect("ChoiceSelected", self, "StoryResponse")
		GameNarrativeDisplay.DisplayText(StoryGenerator.POIStory(POIModel.ActualType, qty),["OK"])
	pass
	
func GetAudioKeyForPOI(POIType):
	match POIType:
		"Artifact":
			return AudioPlayer.AUDIO_KEY.DIALOG_POI_ARTIFACT
		"Resource":
			return AudioPlayer.AUDIO_KEY.DIALOG_POI_RESOURCE
		"Hazard":
			return AudioPlayer.AUDIO_KEY.DIALOG_POI_HAZARD
	return AudioPlayer.AUDIO_KEY.DIALOG_POI_DEFAULT

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
	_setPOIInfo("Exhausted", "Exhausted")
	pass

func _process(delta):
	if poi_node.scale.distance_to(ScaleToVector) <= 0.01:
		poi_node.scale = ScaleToVector
	else:
		poi_node.scale = poi_node.scale.linear_interpolate(ScaleToVector, lerpSpeed * delta)

func get_POIModel():
	return POIModel
	
func set_POIModel(newModel):
	POIModel = newModel
	_refresh()
	
func _refresh():
	for _p in poi_types:
		get_node(_p).visible = false
	poi_node = get_node(POIModel.PerceivedType)
	poi_node.visible = true
	defaultScale = poi_node.scale
	ScaleToVector = defaultScale
	$Hover.text = POIModel.PerceivedType

func _setPOIInfo(poi_type, perceived):
	POIModel.ActualType = poi_type
	POIModel.PerceivedType = perceived
	_refresh()
