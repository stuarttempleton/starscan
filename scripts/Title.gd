extends Control


func _ready():
	GameController.EnterGameLoop(false)
	#AudioPlayer.PlayBG(AudioPlayer.AUDIO_KEY.BG_SPACE)
	AudioPlayer.PlayMusic(AudioPlayer.AUDIO_KEY.MUSIC_TITLE)
	SceneChanger.UnFade(0)
	
	#StarMapData.LoadSave()
	#ShipData.LoadSave()

