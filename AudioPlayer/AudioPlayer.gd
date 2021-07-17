extends Node2D

enum AUDIO_KEY {
	UI_BUTTON_HOVER,
	UI_BUTTON_SELECT,
	
	BG_SPACE,
	BG_BRIDGE,
	BG_SPACE_ANOMALY,
	BG_SPACE_ANOMALY_2,
	
	DIALOG_HAIL,
	DIALOG_OUTPOST,
	DIALOG_POI_DEFAULT,
	DIALOG_POI_ARTIFACT,
	DIALOG_POI_RESOURCE,
	DIALOG_POI_HAZARD,
	DIALOG_WIN,
	DIALOG_LOSE,
	DIALOG_SELECT,
	
	SCAN_OSCILLATOR,
	SCAN_WIN,
	SCAN_LOSE,
	
	MUSIC_WIN,
	MUSIC_LOSE,
	MUSIC_TITLE,
	MUSIC_STAR_MAP,
	MUSIC_SYSTEM_MAP,
	MUSIC_PLANET_MAP,
	MUSIC_OUTPOST,
	MUSIC_TOW
}


export var Audio = {
	AUDIO_KEY.UI_BUTTON_HOVER:"res://Audio/UI/288949__littlerobotsoundfactory__click-electronic-03.ogg",
	AUDIO_KEY.UI_BUTTON_SELECT:"res://Audio/UI/288965__littlerobotsoundfactory__click-electronic-13.ogg",
	
	AUDIO_KEY.BG_SPACE:"res://Audio/BG/270525__littlerobotsoundfactory__ambience-space-00.ogg",
	AUDIO_KEY.BG_BRIDGE:"res://Audio/MUSIC/starscan_transition_bridge_sound.ogg",
	AUDIO_KEY.BG_SPACE_ANOMALY:"res://Audio/BG/270526__littlerobotsoundfactory__ambience-blackhole-00.ogg",
	AUDIO_KEY.BG_SPACE_ANOMALY_2:"res://Audio/BG/270520__littlerobotsoundfactory__ambience-alienhive-00.ogg",
	
	AUDIO_KEY.DIALOG_HAIL:"res://Audio/UI/288953__littlerobotsoundfactory__click-electronic-07.ogg",
	AUDIO_KEY.DIALOG_OUTPOST:"res://Audio/UI/288953__littlerobotsoundfactory__click-electronic-07.ogg",
	AUDIO_KEY.DIALOG_POI_DEFAULT:"res://Audio/MUSIC/starscan_transition_scan_failure.ogg",
	AUDIO_KEY.DIALOG_POI_ARTIFACT:"res://Audio/MUSIC/starscan_transition_scan_success.ogg",
	AUDIO_KEY.DIALOG_POI_RESOURCE:"res://Audio/MUSIC/starscan_transition_scan_success.ogg",
	AUDIO_KEY.DIALOG_POI_HAZARD:"res://Audio/MUSIC/starscan_transition_scan_failure.ogg",
	AUDIO_KEY.DIALOG_WIN:"res://Audio/UI/288953__littlerobotsoundfactory__click-electronic-07.ogg",
	AUDIO_KEY.DIALOG_LOSE:"res://Audio/UI/288953__littlerobotsoundfactory__click-electronic-07.ogg",
	AUDIO_KEY.DIALOG_SELECT:"res://Audio/UI/288957__littlerobotsoundfactory__click-electronic-09.ogg",
	
	AUDIO_KEY.SCAN_OSCILLATOR:"res://Audio/MUSIC/starscan_scan_ping.ogg",
	AUDIO_KEY.SCAN_WIN:"res://Audio/MUSIC/starscan_transition_scan_success.ogg",
	AUDIO_KEY.SCAN_LOSE:"res://Audio/MUSIC/starscan_transition_scan_failure.ogg",
	
	AUDIO_KEY.MUSIC_LOSE:"res://Audio/UI/288965__littlerobotsoundfactory__click-electronic-13.ogg",
	AUDIO_KEY.MUSIC_WIN:"res://Audio/UI/288965__littlerobotsoundfactory__click-electronic-13.ogg",
	AUDIO_KEY.MUSIC_TITLE:"res://Audio/MUSIC/starscan_transition.ogg",
	AUDIO_KEY.MUSIC_STAR_MAP:"res://Audio/MUSIC/starscan_transition_F.ogg",
	AUDIO_KEY.MUSIC_SYSTEM_MAP:"res://Audio/MUSIC/starscan_transition_D.ogg",
	AUDIO_KEY.MUSIC_PLANET_MAP:"res://Audio/UI/288965__littlerobotsoundfactory__click-electronic-13.ogg",
	AUDIO_KEY.MUSIC_OUTPOST:"res://Audio/UI/288965__littlerobotsoundfactory__click-electronic-13.ogg",
	AUDIO_KEY.MUSIC_TOW:"res://Audio/UI/288965__littlerobotsoundfactory__click-electronic-13.ogg"
	
}


#
# BGPlayer is for background/foley audio
# Music player is for looping, long play music
# SFX player is for short samples
#

func _ready():
	pass # Replace with function body.

func StopBG(): $BGPlayer.stop()
func StopBG_2(): $BGPlayer2.stop()
func StopSFX(): $SFXPlayer.stop()
func StopMusic(): $MusicPlayer.stop()

func PlayBG(key):
	$BGPlayer.stream = load(Audio[key])
	$BGPlayer.play()

func PlayBG_2(key):
	$BGPlayer2.stream = load(Audio[key])
	$BGPlayer2.play()


func PlayMusic(key):
	$MusicPlayer.stream = load(Audio[key])
	$MusicPlayer.play()


func PlaySFX(key):
	$SFXPlayer.stream = load(Audio[key])
	$SFXPlayer.play()


func _play_UI_Button_Hover(): PlaySFX(AUDIO_KEY.UI_BUTTON_HOVER)
func _play_UI_Button_Select(): PlaySFX(AUDIO_KEY.UI_BUTTON_SELECT)

var doFade = false
var fade_out = true
var fade_counter = 1.0
var fade_speed = 1.0
func _process(delta):
	if doFade:
		if fade_out:
			fade_counter -= delta * fade_speed
		else:
			fade_counter += delta * fade_speed
		
		if fade_counter < 0:
			fade_counter = 0
			$MusicPlayer.stop()
			fade_out = false #done!
		elif fade_counter > 1:
			fade_counter = 1
			doFade = false #done done!
		#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(fade_counter))
		$MusicPlayer.volume_db = linear2db(fade_counter)

func FadeOutMusic(spd = 1.0):
	fade_counter = 1.0
	fade_speed = spd
	fade_out = true
	doFade = true
	pass
