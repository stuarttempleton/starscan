extends Node2D

enum AUDIO_KEY {
	UI_BUTTON_HOVER,
	UI_BUTTON_SELECT,
	BG_SPACE,
	BG_SPACE_ANOMALY,
	BG_SPACE_ANOMALY_2,
	DIALOG_APPEAR,
	DIALOG_SELECT
}


export var Audio = {
	AUDIO_KEY.UI_BUTTON_HOVER:"res://Audio/UI/288949__littlerobotsoundfactory__click-electronic-03.ogg",
	AUDIO_KEY.UI_BUTTON_SELECT:"res://Audio/UI/288965__littlerobotsoundfactory__click-electronic-13.ogg",
	AUDIO_KEY.BG_SPACE:"res://Audio/BG/270525__littlerobotsoundfactory__ambience-space-00.ogg",
	AUDIO_KEY.BG_SPACE_ANOMALY:"res://Audio/BG/270526__littlerobotsoundfactory__ambience-blackhole-00.ogg",
	AUDIO_KEY.BG_SPACE_ANOMALY_2:"res://Audio/BG/270520__littlerobotsoundfactory__ambience-alienhive-00.ogg",
	AUDIO_KEY.DIALOG_APPEAR:"res://Audio/UI/288953__littlerobotsoundfactory__click-electronic-07.ogg",
	AUDIO_KEY.DIALOG_SELECT:"res://Audio/UI/288957__littlerobotsoundfactory__click-electronic-09.ogg"
}


#
# BGPlayer is for background/foley audio
# Music player is for looping, long play music
# SFX player is for short samples
#

func _ready():
	pass # Replace with function body.


func PlayBG(key):
	$BGPlayer.stream = load(Audio[key])
	$BGPlayer.play()
	print("playing ", Audio[key])


func PlayMusic(key):
	$MusicPlayer.stream = load(Audio[key])
	$MusicPlayer.play()
	print("playing ", Audio[key])


func PlaySFX(key):
	$SFXPlayer.stream = load(Audio[key])
	$SFXPlayer.play()
	print("playing ", Audio[key])


func _play_UI_Button_Hover():
	PlaySFX(AUDIO_KEY.UI_BUTTON_HOVER)


func _play_UI_Button_Select():
	PlaySFX(AUDIO_KEY.UI_BUTTON_SELECT)
