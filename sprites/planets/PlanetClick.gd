extends Area2D


signal planet_selected()
signal planet_hover(planet_position, planet_name)
signal planet_unhover()

func _ready():
	connect("mouse_entered",self,"mouse_enter")
	connect("mouse_exited",self,"mouse_exit")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("planet_selected")

func mouse_enter():
	emit_signal("planet_hover", get_parent().position, get_parent().PlanetName)
	
func mouse_exit():
	emit_signal("planet_unhover")
