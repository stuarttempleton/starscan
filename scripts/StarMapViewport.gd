extends Node2D

func _ready():
	AudioPlayer.PlayBG(AudioPlayer.AUDIO_KEY.BG_SPACE)
	AudioPlayer.PlayBG_2(AudioPlayer.AUDIO_KEY.BG_BRIDGE)
	AudioPlayer.PlayMusic(AudioPlayer.AUDIO_KEY.MUSIC_STAR_MAP)
	if ShipData.Ship().FirstRun:
		_on_FirstPlay()
	GameController.EnableMap()
	# warning-ignore:return_value_discarded
	GameController.connect("map_state", self, "MapToggle")
	
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
	# warning-ignore:return_value_discarded
	GameNarrativeDisplay.connect("ChoiceSelected", self, "StartingTextDone")
	GameNarrativeDisplay.DisplayText(StoryGenerator.Greeting(StarMapData.GetOutpost(nearestOutpostSystem)),["Begin"])


func MapToggle(usemap):
	if usemap:
		$Grid.hide()
		$CanvasLayer/HUD.hide()
		$SystemInformation.get_child(0).hide()
		$MapName/MapUI.show()
	else:
		$Grid.show()
		$CanvasLayer/HUD.show()
		$SystemInformation.get_child(0).show()
		$MapName/MapUI.hide()


func StartingTextDone(_choice):
	ShipData.Ship().FirstRun = false
	GameNarrativeDisplay.disconnect("ChoiceSelected",self,"StartingTextDone")



