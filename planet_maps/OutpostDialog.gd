extends Node2D


var state
var Planet


func _ready():
	state = StoryGenerator.OUTPOST_STATE.LOBBY


func GenerateOptions():
	var opts = []
	var refuel = (ShipData.StarShip.Fuel < ShipData.StarShip.FuelCapacity)
	match state:
		StoryGenerator.OUTPOST_STATE.LOBBY:
			opts.append("Refuel")
			opts.append("Turn in Artifact")
			pass
		StoryGenerator.OUTPOST_STATE.FUEL,StoryGenerator.OUTPOST_STATE.FUEL_FULL:
			opts.append("Station Hub")
			opts.append("Turn in Artifact")
			pass
		StoryGenerator.OUTPOST_STATE.TURN_IN,StoryGenerator.OUTPOST_STATE.TURN_IN_EMPTY:
			opts.append("Station Hub")
			opts.append("Refuel")
			pass
	opts.append("Leave Orbit")
	return opts

func DialogBegin(planet):
	Planet = planet
	state = StoryGenerator.OUTPOST_STATE.LOBBY
	DialogPrompt()
	pass


func DialogPrompt():
	GameNarrativeDisplay.connect("ChoiceSelected", self, "ChoiceRsponses")	
	GameNarrativeDisplay.DisplayText(StoryGenerator.OutpostStory(state, Planet),GenerateOptions())
	pass


func ChoiceRsponses(choice):
	GameNarrativeDisplay.disconnect("ChoiceSelected", self, "ChoiceRsponses")
	match state:
		StoryGenerator.OUTPOST_STATE.LOBBY: ChoiceResponseLobby(choice)
		StoryGenerator.OUTPOST_STATE.FUEL,StoryGenerator.OUTPOST_STATE.FUEL_FULL: ChoiceResponseRefuel(choice)
		StoryGenerator.OUTPOST_STATE.TURN_IN,StoryGenerator.OUTPOST_STATE.TURN_IN_EMPTY: ChoiceResponseTurnIn(choice)
	pass


func ChoiceResponseLobby(choice):
	match choice:
		0: RefuelSelected()
		1: TurnInSeelected()
		2: return LeaveOrbitSelected()
	DialogPrompt()


func ChoiceResponseRefuel(choice):
	match choice:
		0: BackToLobbySelected()
		1: TurnInSeelected()
		2: return LeaveOrbitSelected()
	DialogPrompt()


func ChoiceResponseTurnIn(choice):
	match choice:
		0: BackToLobbySelected()
		1: RefuelSelected()
		2: return LeaveOrbitSelected()
	DialogPrompt()


func BackToLobbySelected():
	state = StoryGenerator.OUTPOST_STATE.LOBBY

func RefuelSelected():
	state = StoryGenerator.OUTPOST_STATE.FUEL_FULL
	if ShipData.StarShip.Fuel < ShipData.StarShip.FuelCapacity:
		state = StoryGenerator.OUTPOST_STATE.FUEL
	ShipData.Refuel()

func TurnInSeelected():
	var qty = ShipData.TurnInArtifacts()
	state = StoryGenerator.OUTPOST_STATE.TURN_IN_EMPTY
	if qty > 0:
		state = StoryGenerator.OUTPOST_STATE.TURN_IN

func LeaveOrbitSelected():
	get_parent().get_parent().get_parent().ViewSystem()
	return true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
