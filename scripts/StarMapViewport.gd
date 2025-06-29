extends Node2D

func _ready():
	AudioPlayer.PlayBG(AudioPlayer.AUDIO_KEY.BG_SPACE)
	AudioPlayer.PlayBG_2(AudioPlayer.AUDIO_KEY.BG_BRIDGE)
	AudioPlayer.PlayMusic(AudioPlayer.AUDIO_KEY.MUSIC_STAR_MAP)
	if ShipData.Ship().FirstRun:
		_on_FirstPlay()
	GameController.EnableMap()
	GameController.EnableCargo()
	# warning-ignore:return_value_discarded
	GameController.connect("map_state", self, "MapToggle")
	
func _on_FirstPlay():
	#deplete fuel to force education about refueling
	ShipData.ConsumeFuel(ShipData.Ship().Fuel)
	
	var shipPos: Vector2
	
	if ShipData.Ship().has("Culture") and ShipData.Ship().Culture.Home:
		shipPos = Vector2(ShipData.Ship().Culture.Home.X, ShipData.Ship().Culture.Home.Y)
	elif StarMapData.StarMap.Cultures.size() > 0 and StarMapData.StarMap.Cultures[0].Home:
		shipPos = Vector2(StarMapData.StarMap.Cultures[0].Home.X, StarMapData.StarMap.Cultures[0].Home.Y)
	else:
		shipPos = Vector2(0.5, 0.5) #default to center of map

	var nearestOutpostSystem = StarMapData.GetNearestOutpostSystem(shipPos)
	if nearestOutpostSystem == null:
		print("FATAL ERROR: the map does not appear to have an outpost, which is required for game play!")
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



