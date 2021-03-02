extends Node2D

func _ready():
	if ShipData.Ship().FirstRun:
		_on_FirstPlay()

func _on_FirstPlay():
	#place at center
	ShipData.Ship().X = 0.5
	ShipData.Ship().Y = 0.5
	
	#deplete fuel to force education about refueling
	ShipData.ConsumeFuel(ShipData.Ship().Fuel)
	
	var shipPos = Vector2(ShipData.Ship().X,ShipData.Ship().Y)
	var nearestOutpostSystem = StarMapData.GetNearestOutpostSystem(shipPos)
	var outpostSystemPos = Vector2(nearestOutpostSystem.X, nearestOutpostSystem.Y) * StarMapData.MapScale
	
	$ShipAvatarView/ShipAvatar.JumpToMapPosition(outpostSystemPos)
	
	#display start up dialog "greetings, nomad!"
	GameNarrativeDisplay.connect("ChoiceSelected", self, "StartingTextDone")
	GameNarrativeDisplay.DisplayText("Greeting",["Begin"])


func StartingTextDone(choice):
	ShipData.Ship().FirstRun = false
	GameNarrativeDisplay.disconnect("ChoiceSelected",self,"StartingTextDone")



