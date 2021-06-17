extends Node2D

func _ready():
	AudioPlayer.PlayBG(AudioPlayer.AUDIO_KEY.BG_SPACE)
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
	
	ShipData.SaveShip()
	AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.DIALOG_HAIL)
	GameNarrativeDisplay.connect("ChoiceSelected", self, "StartingTextDone")
	#GameNarrativeDisplay.DisplayText(StoryGenerator.Lose(),["Begin"])
	GameNarrativeDisplay.DisplayText(StoryGenerator.Greeting(StarMapData.GetOutpost(nearestOutpostSystem)),["Begin"])

#func GetOutpost(system):
#	for planet in system.Planets:
#		if "Outpost" == planet.Type:
#			return planet
#	return false
	
func StartingTextDone(choice):
	ShipData.Ship().FirstRun = false
	GameNarrativeDisplay.disconnect("ChoiceSelected",self,"StartingTextDone")



