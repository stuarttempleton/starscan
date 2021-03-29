extends Area2D


signal selected()
signal hover(_position)
signal unhover()

func _ready():
	connect("mouse_entered",self,"mouse_enter")
	connect("mouse_exited",self,"mouse_exit")
	
func _process(_delta):
#	if (Input.is_mouse_button_pressed(BUTTON_LEFT)):
#		print("LMB")
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("%s registered click: %s" % [self, event.as_text()])

func _input_event(viewport, event, shape_idx):
	#print("POI input event")
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("POI selected")
			emit_signal("selected")

func mouse_enter():
	print("POI hover")
	emit_signal("hover", get_parent().position)
	
func mouse_exit():
	emit_signal("unhover")
