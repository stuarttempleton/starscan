extends Button


func _ready():
	# warning-ignore:return_value_discarded
	connect("pressed",Callable(self,"on_button_pressed"))

func on_button_pressed () :
	AudioPlayer._play_UI_Button_Select()
	# warning-ignore:return_value_discarded
	MessageBox.connect("ChoiceSelected",Callable(self,"ChoiceResponse"))	
	MessageBox.DisplayText("Exit", ["YES","NO"])


func ChoiceResponse(choice):
	MessageBox.disconnect("ChoiceSelected",Callable(self,"ChoiceResponse"))

	match choice:
		-1: return
		0: DoResponse()
		1: return

func DoResponse():
	if ShipData.StarShip.ShipSeedNumber != 0: #note: they haven't been in the game
		StarMapData.SaveMap()
		ShipData.SaveShip()
	AudioPlayer._play_UI_Button_Select()
	SceneChanger.FadeToExit()

