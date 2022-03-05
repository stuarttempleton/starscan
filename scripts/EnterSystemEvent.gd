extends Node2D


func StartEvent():
	if (StarMapData.NearestSystem == null):
		StarMapData.FindNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y))
	var system = StarMapData.NearestSystem
	var EntryCost = ShipData.PayToVisitAStar()
	# warning-ignore:return_value_discarded
	GameNarrativeDisplay.connect("ChoiceSelected", self, "ChoiceMade")
	GameNarrativeDisplay.DisplayText(StoryGenerator.SystemStory(system, EntryCost),["OK"])


func ChoiceMade(_choice):
	GameNarrativeDisplay.disconnect("ChoiceSelected",self,"ChoiceMade")
