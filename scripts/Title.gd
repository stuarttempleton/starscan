extends Control


func _ready():
	GameController.EnterGameLoop(false)
	#AudioPlayer.PlayBG(AudioPlayer.AUDIO_KEY.BG_SPACE)
	AudioPlayer.PlayMusic(AudioPlayer.AUDIO_KEY.MUSIC_TITLE)
	SceneChanger.UnFade(0)
	var vol = db2linear($"/root/AudioPlayer/MusicPlayer".volume_db)
	if vol <= 0.1:
		doFade = true #we are just launching the game.
	
	#StarMapData.LoadSave()
	#ShipData.LoadSave()

var doFade = false
var fade_out = true
var fade_counter = 0
var fade_speed = 1

func _process(delta):
	if doFade:
		fade_counter += delta * fade_speed
		if fade_counter > 1:
			fade_counter = 1
			doFade = false #done done!
		$"/root/AudioPlayer/MusicPlayer".volume_db = linear2db(fade_counter)
		$Nebula/BGAudio.volume_db = linear2db(fade_counter)
