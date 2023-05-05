extends Button


@export var scene_to_load = ""
@export var RemoveFromMenu = false

func _ready():
	if (!StarMapData.SaveExists()):
		RemoveFromMenu = true
	# warning-ignore:return_value_discarded
	connect("pressed",Callable(self,"on_button_pressed"))

func on_button_pressed () :
	if (scene_to_load != "") :
		AudioPlayer._play_UI_Button_Select()
		StarMapData.LoadSave()
		ShipData.LoadSave()
		StarMapData.SetSector(ShipData.Ship().Sector)
		AudioPlayer.FadeOutMusic(2)
		SceneChanger.LoadScene(scene_to_load,0.5)
	else :
		print("THIS MENU BUTTON HAS NO SCENE TO LOAD")

