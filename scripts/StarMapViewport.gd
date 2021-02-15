extends Node2D

func _ready():
	ShipData.connect("FuelTanksEmpty", self, "_on_FuelTanksEmpty")
	if ShipData.Ship().FirstRun:
		_on_FirstPlay()

func _on_FirstPlay():
	#place at center
	ShipData.Ship().X = 0.5
	ShipData.Ship().Y = 0.5
	
	#deplete fuel to force education about refueling
	ShipData.ConsumeFuel(ShipData.Ship().Fuel)
	
	#display start up dialog "greetings, nomad!"
	GameNarrativeDisplay.connect("ChoiceSelected", self, "StartingTextDone")
	GameNarrativeDisplay.DisplayText("Greeting",["Begin"])


func StartingTextDone(choice):
	ShipData.Ship().FirstRun = false
	GameNarrativeDisplay.disconnect("ChoiceSelected",self,"StartingTextDone")


func _on_FuelTanksEmpty():
	var shipPos = Vector2(ShipData.Ship().X,ShipData.Ship().Y)
	var nearestOutpostSystem = StarMapData.GetNearestOutpostSystem(shipPos)
	var outpostSystemPos = Vector2(nearestOutpostSystem.X, nearestOutpostSystem.Y) * StarMapData.MapScale
	print("Setting position directly to " + str(outpostSystemPos))
	$ShipAvatarView/ShipAvatar.JumpToMapPosition(outpostSystemPos)
	ShipData.Refuel()
