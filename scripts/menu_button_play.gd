extends Button


export var scene_to_load = ""
export var RemoveFromMenu = false

func _ready():
	if Input.get_connected_joypads().size() > 0:
		grab_focus()
	if (!StarMapData.SaveExists()):
		RemoveFromMenu = true
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	if (scene_to_load != "") :
		AudioPlayer._play_UI_Button_Select()
		StarMapData.LoadSave()
		ShipData.LoadSave()
		SceneChanger.LoadScene(scene_to_load,0.5)
	else :
		print("THIS MENU BUTTON HAS NO SCENE TO LOAD")

