extends Area2D


signal planet_selected()
signal planet_hover(planet_position, planet_name)
signal planet_unhover()

var clicked = false

func _ready():
	# warning-ignore:return_value_discarded
	connect("mouse_entered",Callable(self,"mouse_enter"))
	# warning-ignore:return_value_discarded
	connect("mouse_exited",Callable(self,"mouse_exit"))

func _input_event(_viewport, event, _shape_idx):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if !clicked:
					emit_signal("planet_selected")
					clicked = true #block for echoes and double clicks

func mouse_enter():
	emit_signal("planet_hover", get_parent().position, get_parent().PlanetName)
	
func mouse_exit():
	emit_signal("planet_unhover")
