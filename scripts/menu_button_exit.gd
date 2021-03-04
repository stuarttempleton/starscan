extends Button


func _ready():
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	StarMapData.SaveMap()
	ShipData.SaveShip()
	AudioPlayer._play_UI_Button_Select()
	get_tree().quit()

