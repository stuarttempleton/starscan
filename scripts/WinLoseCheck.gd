extends Node2D


export var ArtifactsRequiredToWin = 10
var starmap_scene_path = "res://scenes/StarMapViewport.tscn"
var menu_scene_path = "res://scenes/Title.tscn"
var handlingGameOver = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func WinConditionMet():
	return (ShipData.Ship().DeliveredArtifacts > ArtifactsRequiredToWin)


func LoseConditionMet():
	return (ShipData.Ship().Crew < 1)


func DialogTextDone(choice):
	GameNarrativeDisplay.disconnect("ChoiceSelected",self,"DialogTextDone")
	
	StarMapData.ResetMap()
	ShipData.ResetShip()
		
	if choice == 0:
		print("restarting game...")
		get_tree().change_scene(starmap_scene_path)
	elif choice == 1:
		print("returning to menu...")
		get_tree().change_scene(menu_scene_path)
	elif choice == 2:
		print("quiting game...")
		get_tree().quit()


func _process(delta):
	if !handlingGameOver:
		if WinConditionMet():
			print("WIN CONDITION MET")
			handlingGameOver = true
			GameNarrativeDisplay.CancelDialog()
			AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.DIALOG_WIN)
			AudioPlayer.PlayMusic(AudioPlayer.AUDIO_KEY.MUSIC_WIN)
			GameNarrativeDisplay.connect("ChoiceSelected", self, "DialogTextDone")
			GameNarrativeDisplay.DisplayText("Win",["RESTART","MENU","QUIT"])
		elif LoseConditionMet():
			print("LOSE CONDITION MET")
			handlingGameOver = true
			GameNarrativeDisplay.CancelDialog()
			AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.DIALOG_LOSE)
			AudioPlayer.PlayMusic(AudioPlayer.AUDIO_KEY.MUSIC_LOSE)
			GameNarrativeDisplay.connect("ChoiceSelected", self, "DialogTextDone")
			GameNarrativeDisplay.DisplayText("Lose",["RETRY", "MENU","QUIT"])

