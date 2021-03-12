extends Node2D


func _ready():
	if (StarMapData.NearestSystem == null):
		StarMapData.FindNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y))
	var system = StarMapData.NearestSystem
	var EntryCost = ShipData.PayToVisitAStar()
	GameNarrativeDisplay.connect("ChoiceSelected", self, "ChoiceMade")
	GameNarrativeDisplay.DisplayText(StoryGenerator.SystemStory(system, EntryCost),["OK"])


func ChoiceMade(choice):
	GameNarrativeDisplay.disconnect("ChoiceSelected",self,"ChoiceMade")
