extends Button


func _ready():
	if Input.get_connected_joypads().size() > 0:
		grab_focus()
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	GameController.Unpause()

