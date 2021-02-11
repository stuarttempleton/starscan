extends Area2D


signal selected()
signal hover(_position)
signal unhover()

func _ready():
	connect("mouse_entered",self,"mouse_enter")
	connect("mouse_exited",self,"mouse_exit")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("selected")

func mouse_enter():
	#print("mouse entered...")
	emit_signal("hover", get_parent().position)
	
func mouse_exit():
	#print("mouse exited...")
	emit_signal("unhover")
