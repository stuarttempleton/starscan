extends Button


func _ready():
	connect("mouse_entered",self,"mouse_enter")
	connect("mouse_exited",self,"mouse_exit")
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	print("button pressed")

func mouse_enter():
	GameController.EnableDisableMovement(false)
	
func mouse_exit():
	GameController.EnableDisableMovement(true)
