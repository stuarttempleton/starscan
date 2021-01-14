extends Button


func _ready():
	if get_node("../../../..").in_game:
		grab_focus()
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	GameController.Unpause()

