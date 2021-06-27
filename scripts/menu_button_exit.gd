extends Button


func _ready():
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	AudioPlayer._play_UI_Button_Select()
	$"../../../..".YieldFocus(true)
	MessageBox.connect("ChoiceSelected", self, "ChoiceResponse")	
	MessageBox.DisplayText("Exit", ["YES","NO"])


func ChoiceResponse(choice):
	MessageBox.disconnect("ChoiceSelected", self, "ChoiceResponse")
	$"../../../..".YieldFocus(false)
	if Input.get_connected_joypads().size() > 0: 
		grab_focus()
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

