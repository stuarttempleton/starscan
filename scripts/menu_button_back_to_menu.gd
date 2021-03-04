extends Button


export var scene_to_load = ""

func _ready():
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	if (scene_to_load != "") :
		AudioPlayer._play_UI_Button_Select()
		StarMapData.SaveMap()
		ShipData.SaveShip()
		GameNarrativeDisplay.CancelDialog()
		GameController.Unpause()
		get_tree().change_scene(scene_to_load)
	else :
		print("THIS MENU BUTTON HAS NO SCENE TO LOAD")

