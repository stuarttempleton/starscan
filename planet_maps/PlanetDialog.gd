extends Node2D

var Planet
var System


func _ready():
	if StarMapData.NearestSystem != null: 
		System = StarMapData.NearestSystem
	else:
		StarMapData.FindNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y))
		System = StarMapData.NearestSystem


func DialogBegin(planet):
	Planet = planet
	# warning-ignore:return_value_discarded
	GameNarrativeDisplay.connect("ChoiceSelected", self, "ChoiceResponse")	
	GameNarrativeDisplay.DisplayText(StoryGenerator.PlanetStory(System, Planet), ["OK"])


func ChoiceResponse(_choice):
	GameNarrativeDisplay.disconnect("ChoiceSelected", self, "ChoiceResponse")
