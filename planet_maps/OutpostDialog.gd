extends Node2D


var State = StoryGenerator.OUTPOST_STATE.LOBBY
var Planet
var System
var Options = ["Station Hub","Star Dock","Science Bay","Leave Orbit"]
var Qty = 0

func _ready():
	if StarMapData.NearestSystem != null: 
		System = StarMapData.NearestSystem
	else:
		StarMapData.FindNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y))
		System = StarMapData.NearestSystem


func DialogBegin(planet):
	Planet = planet
	State = StoryGenerator.OUTPOST_STATE.LOBBY
	AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.DIALOG_OUTPOST)
	DialogPrompt()


func DialogPrompt():
	GameNarrativeDisplay.connect("ChoiceSelected", self, "ChoiceResponse")	
	GameNarrativeDisplay.DisplayText(StoryGenerator.OutpostStory(State, System, Planet, Qty), Options)


func ChoiceResponse(choice):
	GameNarrativeDisplay.disconnect("ChoiceSelected", self, "ChoiceResponse")
	match choice:
		-1: return
		0: BackToLobbySelected()
		1: RefuelSelected()
		2: TurnInSeelected()
		3: return LeaveOrbitSelected()
	DialogPrompt()


func BackToLobbySelected():
	State = StoryGenerator.OUTPOST_STATE.LOBBY
	


func RefuelSelected():
	State = StoryGenerator.OUTPOST_STATE.FUEL_FULL
	if ShipData.StarShip.Fuel < ShipData.StarShip.FuelCapacity:
		State = StoryGenerator.OUTPOST_STATE.FUEL
	Qty = ShipData.StarShip.FuelCapacity - ShipData.StarShip.Fuel
	ShipData.Refuel()


func TurnInSeelected():
	Qty = ShipData.TurnInArtifacts()
	State = StoryGenerator.OUTPOST_STATE.TURN_IN_EMPTY
	if Qty > 0:
		State = StoryGenerator.OUTPOST_STATE.TURN_IN


func LeaveOrbitSelected():
	get_parent().get_parent().get_parent().ViewSystem()
	return true
