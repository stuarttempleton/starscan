extends Area2D


signal selected()
signal hover(_position)
signal unhover()

func _ready():
	# warning-ignore:return_value_discarded
	connect("mouse_entered",self,"mouse_enter")
	# warning-ignore:return_value_discarded
	connect("mouse_exited",self,"mouse_exit")
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			pass

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("selected")

func mouse_enter():
	emit_signal("hover", get_parent().position)
	
func mouse_exit():
	emit_signal("unhover")
