extends Button


func _ready():
	# warning-ignore:return_value_discarded
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	GameController.Unpause()

