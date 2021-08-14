extends Node2D


export var ArtifactsRequiredToWin = 10
var starmap_scene_path = "res://scenes/StarMapViewport.tscn"
var menu_scene_path = "res://scenes/Title.tscn"
var handlingGameOver = false
var isInGame = false
var viewing_stats = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func WinConditionMet():
	return (ShipData.Ship().DeliveredArtifacts >= ArtifactsRequiredToWin)


func LoseConditionMet():
	return (ShipData.Ship().Crew < 1)

func Reset():
	StarMapData.ResetMap()
	ShipData.ResetShip()
	handlingGameOver = false

func DialogTextDone(choice):
	GameNarrativeDisplay.disconnect("ChoiceSelected",self,"DialogTextDone")
	if choice == 0:
		GameNarrativeDisplay.connect("ChoiceSelected", self, "DialogTextDone")
		viewing_stats = !viewing_stats
		if viewing_stats:
			GameNarrativeDisplay.DisplayText(StoryGenerator.PlayStats(),["MESSAGE","MENU","QUIT"])
		else:
			GameNarrativeDisplay.DisplayText(GetStoryText(),["STATS","MENU","QUIT"])
	elif choice == 1:
		Reset()
		SceneChanger.LoadScene(menu_scene_path, 0.0)
	elif choice == 2:
		Reset()
		get_tree().quit()

func GetStoryText():
	if WinConditionMet():
		return StoryGenerator.Win()
	else:
		return StoryGenerator.Lose()

func _process(_delta):
	if !handlingGameOver && isInGame:
		if WinConditionMet():
			handlingGameOver = true
			GameNarrativeDisplay.CancelDialog()
			AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.DIALOG_WIN)
			AudioPlayer.PlayMusic(AudioPlayer.AUDIO_KEY.MUSIC_WIN)
			GameNarrativeDisplay.connect("ChoiceSelected", self, "DialogTextDone")
			GameNarrativeDisplay.DisplayText(GetStoryText(),["STATS","MENU","QUIT"])
		elif LoseConditionMet():
			handlingGameOver = true
			GameNarrativeDisplay.CancelDialog()
			AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.DIALOG_LOSE)
			AudioPlayer.PlayMusic(AudioPlayer.AUDIO_KEY.MUSIC_LOSE)
			GameNarrativeDisplay.connect("ChoiceSelected", self, "DialogTextDone")
			GameNarrativeDisplay.DisplayText(GetStoryText(),["STATS","MENU","QUIT"])

